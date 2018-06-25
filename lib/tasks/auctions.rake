desc "Check for active auctions that already ended resolve outcome and send out emails, also auto reject and auto accept outcome if applicable"
task :resolve_auctions => :environment do
  Auction.resolve_finished_auctions
  Auction.reject_acutions_users_can_no_longer_confirm
  Auction.accept_auctions_vendors_can_no_longer_reject
  Auction.accept_affiliate_offer_after_waiting_period
end

desc "Send reminders about unconfirmed auctions"
task :send_unconfirmed_auctions_reminders => :environment do
  if EmailContent.first_confirmation_reminder_mail?
    end_time_before = Time.now - AuctionOutcome::FIRST_CONFIRMATION_REMINDER_AFTER
    Auction.includes(:outcome).
      where(['auctions.end_time < ? AND status="unconfirmed"', end_time_before]).
      each do |auction|
      next unless auction.outcome.first_reminder_sent_at.nil?
      AuctionsMailer.first_confirmation_reminder(auction).deliver
      auction.outcome.update_attribute :first_reminder_sent_at, Time.now
    end
  end

  if EmailContent.last_confirmation_reminder_mail?
    end_time_before = Time.now - Auction::CANT_CONFIRM_AFTER + AuctionOutcome::LAST_CONFIRMATION_BEFORE_DEADLINE
    Auction.includes(:outcome).
      where(['auctions.end_time < ? AND status="unconfirmed"', end_time_before]).
      each do |auction|
      next unless auction.outcome.second_reminder_sent_at.nil?
      AuctionsMailer.last_confirmation_reminder(auction).deliver
      auction.outcome.update_attribute :second_reminder_sent_at, Time.now
    end
  end
end

desc "Send recommendations to vendor"
task :send_vendor_recommendations => :environment do
  Vendor.where('recommendations_sent_at < ? OR recommendations_sent_at IS NULL', Time.now - Vendor::SENT_RECOMMENDATIONS_EVERY).each do |vendor|
    vendor.send_recommendations
  end
end

