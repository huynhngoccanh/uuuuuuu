class Users::ReferredVisitsController < ApplicationController
  layout 'ubitru'
  

  def index
    if current_user
      @referred_users_order = params[:referred_users_order] || 'users.created_at'
      @referred_users_dir = params[:referred_users_dir] == 'DESC' ? :DESC : :ASC
      
      @referred_users_order = "sum(auctions.user_earnings)" if @referred_users_order == 'treshold_met'
      
      @referred_users = InviteUser.where(user_id: current_user).all
      # @referred_users = current_user.referred_visits.
      #                   joins('INNER JOIN `users` ON `users`.`referred_visit_id` = `referred_visits`.`id`
      #                   LEFT OUTER JOIN `auctions` ON `auctions`.`user_id` = `users`.`id`').
      #                   where('(auctions.status = "accepted" OR auctions.status IS NULL)').
      #                   select('referred_visits.*, sum(auctions.user_earnings) as referred_user_total_earnings,
      #                   users.email as referred_user_email, users.created_at as referred_user_created_at').
      #                   group('referred_visits.id').
      #                   order("#{@referred_users_order} #{@referred_users_dir}").paginate(:page=>params[:page], :per_page=>30)  
    else
      redirect_to :back , notice: 'Please! sign in first'
    end

  end
  
  def get_contact_list
    adapter = Contacts::Gmail
    adapter = Contacts::Yahoo unless params['yahoo'].blank?  
    begin
      @contacts = adapter.new(params[:email_username], params[:email_password]).contacts
    rescue Contacts::AuthenticationError
      flash.now[:alert] = "Invalid email / password combination"
    rescue
      flash.now[:alert] = "Error retreving contacts"
    end
  end
  
  def referral  
  end
  
  def send_email_invites
    recipients = params[:contacts] || []
      if params[:emails]
        recipients = params[:emails].split(/[,\n;]/).map{|e| e.strip}
      end
    error_mails = []
    recipients.each do |email|
      error_mails.push email if (email =~ /\A.+@.+\..+\Z/).nil?
    end
    if error_mails.blank?
      ReferralsMailer.delay.invite(current_user, recipients)
      flash.now[:notice] = "Successfully sent invitations to Ubitru"
    else
      msg = "Some of the emails don't look correct: "
      msg += error_mails.map{|m| '"'+view_context.content_tag(:strong){m}+'"'}.join(',')
      msg += '. Please correct them and try again.'
      flash.now[:alert] = msg.html_safe
    end
  end
  
  
end
