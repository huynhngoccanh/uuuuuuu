class PaypalNotificationsController < ApplicationController
  layout false
  
  protect_from_forgery :except => [:notify]
  
  def notify
    render :nothing => true
    
    return if params['txn_type'] != 'masspay'
    
    withdrawal = FundsWithdrawal.find_by_encoded_id params[:unique_id_1]
    
    FundsWithdrawalNotification.create!(
      :funds_withdrawal_id => (withdrawal && withdrawal.id),
      :status => params[:status_1],
      :receiver_email => params[:receiver_email_1],
      :transaction_id => params[:masspay_txn_id_1],
      :params => params
      
    ) 
  end
  
end
