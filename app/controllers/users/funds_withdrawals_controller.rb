class Users::FundsWithdrawalsController < ApplicationController
  layout 'ubitru'
  before_action :authenticate_user!  
  before_action :disallow_unconfirmed, :only=>['new','create']
  skip_before_filter :verify_authenticity_token

  def index
    @withdrawal = current_user.funds_withdrawals.build(:paypal_email=>current_user.email)
    list_earnings_and_withdrawals(current_user)
  end

  def new
    @withdrawal = current_user.funds_withdrawals.build(:paypal_email=>current_user.email)
  end

  
  def process_payment
    @withdrawal, success_message, error_message = current_user.process_payment(params[:funds_withdrawal])
    if error_message
      flash[:alert] = error_message
      respond_to do |format|
        format.html{redirect_to url_for(:action=>'index') and return }
        format.json do 
          render json: {error: error_message}, status: :unprocessable_entity
          return
        end
      end
    else
      respond_to do |format|
        format.html do
          redirect_to url_for(:action=>'index'), :notice => success_message
        end
        format.json { render json: {notice: success_message}, status: :created}
      end      
    end    
  end

  def create
    @withdrawal, success_message, error_message = current_user.withdraw_funds(params[:funds_withdrawal])
    if error_message
      respond_to do |format|
        format.html{redirect_to url_for(:action=>'index'), :alert => error_message and return }
        format.json do 
          render json: {error: error_message}, status: :unprocessable_entity
          return
        end
      end
    else
      respond_to do |format|
        format.html do
          redirect_to url_for(:action=>'index'), :notice => success_message
        end
        format.json { render json: {notice: success_message}, status: :created}
      end      
    end
    

#    @withdrawal = current_user.funds_withdrawals.build(params[:funds_withdrawal])
#    if @withdrawal.save
#      #if @withdrawal.execute
#      withdrawal_request = @withdrawal.execute_withdrawal_request
#      if withdrawal_request[:success]
#        redirect_to url_for(:action=>'index'), :notice => "Your withdrawal was successfully saved."
#      else
#        session.delete(:withdrawal_errors) if session.has_key?(:withdrawal_errors)
#        session[:withdrawal_errors] = withdrawal_request[:errors]
#        redirect_to url_for(:action=>'index', :errors => true)
#      end
#    else
#      flash[:alert] = 'Withdrawal saving error.'
#      unless @withdrawal.errors[:updated_at].blank?
#        time_to_wait = view_context.distance_of_time_in_words(FundsWithdrawal::MIN_TIME_BETWEEN_WITHDRAWALS)
#        flash[:alert] = "You have to wait at least #{time_to_wait} before withdrawing funds again"
#      end
#      redirect_to url_for(:action=>'index')
#    end
  end

end
