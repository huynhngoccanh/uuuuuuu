class FundsWithdrawal < ActiveRecord::Base
  MIN_AMOUNT = 30
  MAX_AMOUNT = 100
  MIN_TIME_BETWEEN_WITHDRAWALS = 1.day

  include EncodableModelIds

  belongs_to :user

  has_many :notifications, :class_name => "FundsWithdrawalNotification"

  validates :amount, :presence=>true,
      :numericality=>{
        :greater_than_or_equal_to => MIN_AMOUNT, :only_integer => true,
        :less_than_or_equal_to => MAX_AMOUNT}

# validate :cant_withdraw_too_often

  validates_less_or_equal_to_other_attr :amount, :user_balance
  
  attr_accessible :amount, :paypal_email

  serialize :params

  def amount_in_cents
    (amount * 100).round
  end

  def execute   
    if self.valid?
      response = PAYPAL_STANDARD_GATEWAY.transfer(amount_in_cents, paypal_email || user.email, {
        :subject => 'Your MuddleMe earnings that you withdrawed are available at PayPal.',
        :unique_id => encoded_id
      })
      #save gateways response details so there is a log of what happened
      self.response = response

      if response.success?
        self.resulting_balance = SystemStats.system_balance - amount
      end

      save!

      if response.success?
        UserTransaction.create_for self
        TransferFee.create_for self
      end

      response.success?
    else
      false
    end
  end

  def execute_withdrawal_request
    #Check account balance to decide the funding source.
    funding_source = "BALANCE"
    if check_account_balance[:success]
      if check_account_balance[:balance].to_i < amount
        funding_source = "ECHECK"
      else
        funding_source = "BALANCE"
      end
    end

    #Build request object
    pay = PAYPAL_ADAPTIVE_PAYMENT_GATEWAY.build_pay({
      :actionType => "PAY", :currencyCode => "USD", :feesPayer => "SENDER",
      :senderEmail => SOCIAL_CONFIG['paypal_sender_email'], :requestEnvelope => { :errorLanguage => "en_US"},
      :receiverList => { :receiver => [{ :amount => amount, :email => paypal_email || user.email, :paymentType => "PERSONAL" }] },
      :fundingConstraint => { :allowedFundingType => { :fundingTypeInfo => [{ :fundingType => funding_source }] } },
      :returnUrl => HOSTNAME_CONFIG['return_url'],  :cancelUrl => HOSTNAME_CONFIG['cancel_url']
    })

    # Make API call & get response
    pay_response = PAYPAL_ADAPTIVE_PAYMENT_GATEWAY.pay(pay)
    Rails.logger.debug "\n--------THIS IS RESPONSE:::::--------\n #{pay_response.inspect} \n--------END OF RESPONSE:::::--------\n "
    self.response = pay_response
    save!

    # Access Response
    if pay_response.success?
      self.resulting_balance = SystemStats.system_balance - amount
      UserTransaction.create_for self
      TransferFee.create_for self
    else
      failure_errors = pay_response.error.map{|e| [e.try(:message)]}
      Rails.logger.debug "\n--------FULL ERROR TRACE:::::--------\n #{failure_errors.inspect} \n--------END OF ERRORS:::::--------\n "
      failure_errors.push("Please try again after some time.")
    end
    {:success => pay_response.success?, :errors => (failure_errors.present?) ? failure_errors : nil }
  end

  def self.check_account_balance
    check_balance = PAYPAL_MERCHANT_PAYMENT_GATEWAY.build_get_balance({:ReturnAllCurrencies => "0" })
    get_balance_response = PAYPAL_MERCHANT_PAYMENT_GATEWAY.get_balance(check_balance)
    if get_balance_response.success?
      act_bal = get_balance_response.balance.value
    else
      errors = PAYPAL_MERCHANT_PAYMENT_GATEWAY.logger.error(get_balance_response.Errors[0].LongMessage)
    end
    {:success => get_balance_response.success?, :balance => (act_bal.present?) ? act_bal : nil, :errors => (errors.present?) ? errors : nil }
  end

  def response=(response)
    if response.class.name.include? "AdaptivePayments"
      self.success = response.success?
      self.message = response.responseEnvelope.ack
      self.params = response
    else
      self.success       = response.success?
      self.authorization = response.authorization
      self.message       = response.message
      self.params        = response.params
    end
  rescue ActiveMerchant::ActiveMerchantError => e
    self.success       = false
    self.authorization = nil
    self.message       = e.message
    self.params        = {}
  end


  def cant_withdraw_too_often
    last_withdrawal = user.funds_withdrawals.where(:success=>true).order('updated_at DESC').first
    if last_withdrawal && last_withdrawal.updated_at + MIN_TIME_BETWEEN_WITHDRAWALS > Time.now
      errors.add(:updated_at, "too soon to withdraw funds")
    end
  end

  def self.process_delayed_withdrawals
    @users = User.eager_load(:withdrawal_request).where("#{WithdrawalRequest.table_name}.id IS NOT NULL")
    unless @users.blank?
      balance_check = FundsWithdrawal.check_account_balance
      @users.each do |user|
        if balance_check[:balance].to_i >= user.withdrawal_request.amount.to_i
          @withdrawal = user.funds_withdrawals.build(:amount => user.withdrawal_request.amount,
                                                                                     :paypal_email => user.withdrawal_request.paypal_email,
                                                                                     :user_balance => user.withdrawal_request.user_balance)
          if @withdrawal.save
            if @withdrawal.execute
              user.withdrawal_request.delete
              ReferralsMailer.send_passive_payment_alert(user).deliver
              [@withdrawal, "Payment for User: #{user.email} is successful \n", nil]
            else
              [@withdrawal, nil, "FAILURE: Payment for User: #{user.email} is Failed \n"]
            end
          end
        else
          [nil, nil, "Insufficent funds"]
        end
      end
    else
      puts "No pending payment requests present"
    end

  end

  def user_balance
    user.balance || 0
  end
  def user_balance= val
  end
end
