class FundsWithdrawalNotification < ActiveRecord::Base
  belongs_to :funds_withdrawal
  serialize :params
  
  after_create :check_status
  
  def check_status
    return if !funds_withdrawal || !funds_withdrawal.success
    if ['Failed','Returned','Reversed'].include?(status)
      #refund funds
      UserTransaction.create_for self
      funds_withdrawal.update_attribute(:success, false)

      funds_withdrawal.update_attribute(:resulting_balance, SystemStats.system_balance - funds_withdrawal.amount)
    end
  end
end
