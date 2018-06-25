class ReferredVisit < ActiveRecord::Base
  belongs_to :user
  belongs_to :sales_group
  has_one :referred_user, :class_name=> 'User'
  validates :user_id, :presence=>true

  EARNINGS_TRESHOLD = 30
  EARNINGS_PER_REFERRED_USER_PERCENTAGE = 10
  
  def add_referred_earnings comission_amount
    return if comission_amount.blank? || referred_user.blank? || referred_user.created_at > (Time.now - 1.year) ## add earnings for first year and if user exists

    update_attribute :earnings, EARNINGS_PER_REFERRED_USER_PERCENTAGE * comission_amount
  end
end
