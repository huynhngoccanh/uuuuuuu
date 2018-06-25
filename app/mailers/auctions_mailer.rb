class AuctionsMailer < ActionMailer::Base
  default :from => "\"Ubitru Support\" <noreply@#{HOSTNAME_CONFIG['hostname']}>"
  helper 'application'
  helper 'admins/email_contents'

  def auction_initiated_user auction
    @auction = auction
    @user = auction.user
    @email_content = EmailContent.find_by_name("auction_initiated_user")

    [
        'emails/user_logo.png'
    ].each do |file|
      attachments.inline[file] = File.read("#{Rails.root.to_s}/app/assets/images/#{file}")
    end

    mail :to => @user.email, :subject=> "Ubitru auction initiated."
  end

  # send mail to user that auction ended with no bids
  def auction_ended_user auction
    @auction = auction
    @user = auction.user
    @email_content = EmailContent.find_by_name("auction_ended_user")

    [
        'emails/user_logo.png'
    ].each do |file|
      attachments.inline[file] = File.read("#{Rails.root.to_s}/app/assets/images/#{file}")
    end

    mail :to => @user.email, :subject=> "Ubitru auction ended."
  end

  # send mail to user that auction was won
  def auction_won_user auction
    @auction = auction
    @user = auction.user
    @email_content = EmailContent.find_by_name("auction_won_user")

    [
      'emails/user_logo.png',
      'emails/view-offers-button.png',
    ].each do |file|
      attachments.inline[file] = File.read("#{Rails.root.to_s}/app/assets/images/#{file}")
    end
    
    mail :to => @user.email, :subject=> "Ubitru auction ended. You have offers for #{@auction.name}"
  end

  def auction_ended_from_affiliate auction, affiliate_offer
    @auction = auction
    @affiliate_offer = affiliate_offer
    @user = auction.user
    @email_content = EmailContent.find_by_name("auction_ended_from_affiliate")

    [
      'emails/user_logo.png',
    ].each do |file|
      attachments.inline[file] = File.read("#{Rails.root.to_s}/app/assets/images/#{file}")
    end
    
    mail :to => @user.email, :subject=> "You have cash!"
  end
  # send mail to vendor that he won the auction
  def auction_won_vendor auction, vendor
    @auction = auction
    @vendor = vendor
    @email_content = EmailContent.find_by_name("auction_won_vendor")

    [
      'emails/vendor_logo.png',
      'emails/view-lead-button.png',
    ].each do |file|
      attachments.inline[file] = File.read("#{Rails.root.to_s}/app/assets/images/#{file}")
    end
    
    mail :to => @vendor.email, :subject=> "Ubitru - you have won an search! Contact your lead today."
  end

  def auction_has_some_bids_user auction
    @auction = auction
    @user = auction.user
    @email_content = EmailContent.find_by_name("auction_has_some_bids_user")

    [
      'emails/user_logo.png'
    ].each do |file|
      attachments.inline[file] = File.read("#{Rails.root.to_s}/app/assets/images/#{file}")
    end
    
    mail :to => @user.email, :subject=> "You have bids for auction:  #{@auction.name}"
  end
  
  def first_confirmation_reminder auction
    @auction = auction
    @user = auction.user
    @email_content = EmailContent.find_by_name("first_confirmation_reminder")

    [
      'emails/user_logo.png',
      'emails/provide-outcome-button.png',
    ].each do |file|
      attachments.inline[file] = File.read("#{Rails.root.to_s}/app/assets/images/#{file}")
    end
    
    days = ((Time.now - auction.end_time)/(3600 * 24)).round
    
    mail :to => @user.email, :subject=> "Your Ubitru auction for #{@auction.name} ended #{days} days ago. Provide feedback to claim your earnings!"
  end
  
  def last_confirmation_reminder auction
    @auction = auction
    @user = auction.user
    @email_content = EmailContent.find_by_name("last_confirmation_reminder")

    [
      'emails/user_logo.png',
      'emails/provide-outcome-button.png',
    ].each do |file|
      attachments.inline[file] = File.read("#{Rails.root.to_s}/app/assets/images/#{file}")
    end
    
    days = ((Time.now - auction.end_time)/(3600 * 24)).round
    
    mail :to => @user.email, :subject=> "You only have #{days} days to provide feedback to claim your earnings for your auction for #{@auction.name}!"
  end
  
  def vendor_confirm_outcome auction, vendor
    @auction = auction
    @vendor = vendor
    @vendor_outcome = @auction.outcome.vendor_outcomes.find_by_vendor_id @vendor.id
    return false if !@vendor_outcome
    @email_content = EmailContent.find_by_name("vendor_confirm_outcome")

    [
      'emails/vendor_logo.png',
      'emails/confirm-outcome-button.png'
    ].each do |file|
      attachments.inline[file] = File.read("#{Rails.root.to_s}/app/assets/images/#{file}")
    end
    
    mail :to => @vendor.email, :subject=> "Ubitru - confirm auction outcome for #{@auction.name}."
  end
  
  def low_funds_notification vendor, campaign = nil
    @vendor = vendor
    @campaign = campaign

    if @campaign.nil?
      @email_content = EmailContent.find_by_name("low_funds_notification_global")
    else
      @email_content = EmailContent.find_by_name("low_funds_notification_campaign")
    end

      [
      'emails/vendor_logo.png'
    ].each do |file|
      attachments.inline[file] = File.read("#{Rails.root.to_s}/app/assets/images/#{file}")
    end
    
    subject_line = 'your funds are running low.'
    subject_line = 'campaign budget is running low.' unless @campaign.nil?
    
    mail :to => @vendor.email, :subject=> "Ubitru - #{subject_line}"
  end
  
  def recommended_auctions vendor, auctions
    @vendor = vendor
    @auctions = auctions
    @email_content = EmailContent.find_by_name("recommended_auctions")

    [
      'emails/vendor_logo.png',
      'emails/view-recommendations-button.png'
    ].each do |file|
      attachments.inline[file] = File.read("#{Rails.root.to_s}/app/assets/images/#{file}")
    end
    
    mail :to => @vendor.email, :subject=> "Ubitru - todays recommended auctions"
  end
  
end
