class ContactMailer < ActionMailer::Base
  helper 'application'

  default :from => "support@ubitru.com"
  default :to => "kevin@Ubitru.com"
  default :subject => "[contact form] Question from user"

  def contact_mail(contact_message, from_whom)
    @contact_message = contact_message
    @from_whom = from_whom

    if @from_whom.class == User
      @sub = "Customer question"
    elsif @from_whom.class == Vendor
      @sub ="Company question"
    elsif @from_whom.nil?
      @sub ="Unregistered user question"
    end

    mail :from => @contact_message.email, :subject=> "[contact form] #{@sub}"
  end

  def withdrawal_request_update(user)
    @user = user
    mail :subject => "New withdrawal Request"
  end

  def test_mail_from_production_schedular
    mail :to => "sandeep@rubyeffect.com", :subject => "Test Mail from production schedular"
  end

  def new_advertisers_data_notification(affiliate, email)
    @affiliate = affiliate
    mail :to => email, :subject => "New #{affiliate} advertisers information update"
  end

  def new_coupons_data_notification(affiliate, email)
    @affiliate = affiliate
    mail :from => "support@ubitru.com", :to => email, :subject => "New #{affiliate} coupons information update"
  end

  def user_direct_sign_up(user, account_pwd)
    @user = user
    @account_pwd = account_pwd
    mail :to => user.email, :subject => "Welcome to Ubitru"
  end

  def send_coupons_notification(coupon, email)
    @coupon = coupon
    @email = email
    mail :from => "support@ubitru.com", :to => email, :subject => "#{@coupon} coupons information update"
  end
end
