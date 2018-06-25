class PaymentHistory < ActiveRecord::Base
  
  belongs_to :user

  validate :withdraw_amount 
  validates :paypal_email, :amount, presence: :true
  validates :amount ,:numericality=>{
        :greater_than => 0}

  def withdraw_amount
    if !self.amount.blank? 
      amount_withdraw = User.find(self.user_id).balance
      if self.amount > amount_withdraw
      
        self.errors.add(:base, "Insufficent funds")
      end
    end
  end

end
