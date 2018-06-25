class AddLowFundsNotificationSentAt < ActiveRecord::Migration
  def change
    add_column :vendors, :low_funds_notification_sent_at, :datetime
    add_column :campaigns, :low_funds_notification_sent_at, :datetime
  end
end
