class UserCoupon < ActiveRecord::Base
  belongs_to :advertisable, :polymorphic => true
  has_one :printable_coupon
  belongs_to :user
  #validates_presence_of :store_website, :offer_type, :code, :discount_description

  SPAM = ['spam1', 'spam2', 'spam3']

  def advertiser
    self.advertisable
  end

  def self.check_spam_in_discount_description(description)
    spam_status = true
    description_array = description.split(" ")
    common_words = UserCoupon::SPAM & description_array
    spam_status = false if common_words.blank?
    spam_status
  end
end
