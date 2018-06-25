class ReferralsMailer < ActionMailer::Base
  default :from => "<noreply@ubitru.com>"
  helper 'application'

  def invite (user, recipients)
    @recipients = 'recipients'
    @referral= InviteUser.where(user_id: user.id).last
    @user = user
    # @token = InviteUsers.where
    @url = new_referred_user_registration_url(@referral.token)
    mail :to => recipients,:subject=> "Check out this new website: Ubitru.com!"
  end
  
  def send_passive_payment_alert(user)
    @user = user
    mail :to => "sandeep@rubyeffect.com", :subject => "Passive payment notification from Ubitru"
  end
  
end
