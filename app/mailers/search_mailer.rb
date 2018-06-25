class SearchMailer < ActionMailer::Base
  default :from => "\"Ubitru Support\" <noreply@#{HOSTNAME_CONFIG['hostname']}>"
  helper 'application'
  helper 'admins/email_contents'

  def earnings_notification(merchant, intent, comission)
    @intent = intent
    @user = intent.user
    @email_content = EmailContent.find_by_name("earnings_notification")
  end

  def search_ended_from_affiliate search, merchant
    @search = search
    @merchant = merchant
    @user = search.user
    @email_content = EmailContent.find_by_name("auction_ended_from_affiliate")

    [
        'emails/user_logo.png',
    ].each do |file|
      attachments.inline[file] = File.read("#{Rails.root.to_s}/app/assets/images/#{file}")
    end

    mail :to => @user.email, :subject=> "You have cash!"
  end

  def search_ended_from_soleo(search)
    @search = search
    @user = search.user
    @email_content = EmailContent.find_by_name('search_ended_from_soleo')

    [
        'emails/user_logo.png',
    ].each do |file|
      attachments.inline[file] = File.read("#{Rails.root.to_s}/app/assets/images/#{file}")
    end

    mail :to => @user.email, :subject=> 'You have cash pending!'
  end

  def soleo_pending_outcome_provided(search, outcome)
    @search = search
    @user = search.user
    @outcome = outcome
    @merchant = Search::SoleoMerchant.find(outcome.merchant_id)

    mail :to => 'kevin@Ubitru.com', :subject=> 'Outcome report provided by user ' + @user.full_name
  end

  def coupons_available_near_user(merchants, user)
    @merchants = merchants
    @user = user
    mail :to => user.email, :subject=> 'Coupons available'
  end

  def search_error_notification(developer_email, error_message, query)
    @error = error_message
    @query = query
    mail :to => developer_email, :subject => "MM Search Error for query string: #{query}"
  end

end
