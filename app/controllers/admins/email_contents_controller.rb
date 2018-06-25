class Admins::EmailContentsController < Admins::ApplicationController

  def index
    @confirmation_instructions_user = EmailContent.find_by_name('confirmation_instructions_user')
    @auction_initiated_user = EmailContent.find_by_name('auction_initiated_user')
    @auction_won_user = EmailContent.find_by_name('auction_won_user')
    @auction_ended_user = EmailContent.find_by_name('auction_ended_user')
    @auction_ended_from_affiliate = EmailContent.find_by_name('auction_ended_from_affiliate')
    @search_ended_from_soleo = EmailContent.find_by_name('search_ended_from_soleo')
    @auction_has_some_bids_user = EmailContent.find_by_name('auction_has_some_bids_user')
    @first_confirmation_reminder = EmailContent.find_by_name('first_confirmation_reminder')
    @last_confirmation_reminder = EmailContent.find_by_name('last_confirmation_reminder')
    @referrals_invite = EmailContent.find_by_name('referrals_invite')

    @confirmation_instructions_vendor = EmailContent.find_by_name('confirmation_instructions_vendor')
    @recommended_auctions = EmailContent.find_by_name('recommended_auctions')
    @auction_won_vendor = EmailContent.find_by_name('auction_won_vendor')
    @low_funds_notification_global = EmailContent.find_by_name('low_funds_notification_global')
    @low_funds_notification_campaign = EmailContent.find_by_name('low_funds_notification_campaign')
    @vendor_confirm_outcome = EmailContent.find_by_name('vendor_confirm_outcome')
  end

  def edit
    @email_content = EmailContent.find(params[:id])
  end

  def update
    @email_content = EmailContent.find(params[:id])

    respond_to do |format|
      if @email_content.update_attributes(params[:email_content])
        notice = 'Your settings were successfully updated.'
        format.html { redirect_to(:back, :notice => notice) }
        format.js {
          flash.now[:notice] = notice
          render 'application/show_flash'
        }
      else
        alert = 'Something went wrong. Please try again.'
        format.html { redirect_to(:back, :alert => alert) }
        format.js {
          flash.now[:alert] = alert
          render 'application/show_flash'
        }
      end
    end

  end

  def preview
    @email_content = EmailContent.find(params[:id])
  end


end
