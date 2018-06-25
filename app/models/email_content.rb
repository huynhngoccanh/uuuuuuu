class EmailContent < ActiveRecord::Base
  validates :name, :uniqueness => true

  def self.auction_initiated_user_mail?
    find_by_name('auction_initiated_user').send_mail?
  end

  def self.auction_ended_user_mail?
    find_by_name('auction_ended_user').send_mail?
  end

  def self.auction_won_user_mail?
    find_by_name('auction_won_user').send_mail?
  end

  def self.auction_won_vendor_mail?
    find_by_name('auction_won_vendor').send_mail?
  end

  def self.first_confirmation_reminder_mail?
    find_by_name('first_confirmation_reminder').send_mail?
  end

  def self.last_confirmation_reminder_mail?
    find_by_name('last_confirmation_reminder').send_mail?
  end

  def self.vendor_confirm_outcome_mail?
    find_by_name('vendor_confirm_outcome').send_mail?
  end

  def self.low_funds_notification_global_mail?
    find_by_name('low_funds_notification_global').send_mail?
  end

  def self.low_funds_notification_campaign_mail?
    find_by_name('low_funds_notification_campaign').send_mail?
  end

  def self.recommended_auctions_mail?
    find_by_name('recommended_auctions').send_mail?
  end

end
