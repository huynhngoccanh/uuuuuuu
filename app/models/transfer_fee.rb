class TransferFee < ActiveRecord::Base
  belongs_to :feeable, :polymorphic => true

  def self.create_for feeable
    feeable_type = feeable.class.name

    amount = 0
    if feeable_type == 'FundsTransfer'
      return nil if feeable.status != 'success'
      if feeable.use_credit_card
        #authorize.net fee
        #http://www.authorize.net/solutions/merchantsolutions/pricing/
        amount = 0.05
      else
        #paypal standard account merchant fee
        #https://www.paypal.com/webapps/mpp/paypal-fees
        amount = (feeable.amount * 0.029) + 0.3
      end
    end
    if feeable_type == 'FundsWithdrawal'
      return nil if !feeable.success
      #paypal mass payment fee
      #https://www.paypal.com/us/cgi-bin/?cmd=_batch-payment-overview-outside
      amount = feeable.amount * 0.02
    end

    system_balance = SystemStats.system_balance
    return self.create!({
      :feeable=>feeable,
      :amount=>amount,
      :resulting_balance => system_balance - amount
    })
  end
end
