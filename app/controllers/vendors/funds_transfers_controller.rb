class Vendors::FundsTransfersController < ApplicationController
  def index
    @transfer = current_vendor.funds_transfers.build
    @transfer.amount = session[:vendor_tranfer_amount]
    @refund = current_vendor.funds_refunds.build if current_vendor.balance.to_i > 0

    list_transfers_and_refunds(current_vendor)
  end
  
  def create
    @transfer = current_vendor.funds_transfers.build(params[:funds_transfer])
    @transfer.ip_address = request.remote_ip
    if @transfer.save
      if @transfer.use_credit_card?
        #credit card transfer
        if @transfer.execute
          msg = "Sucessfully transfered #{view_context.format_currency(@transfer.amount)} from your credit card to your Ubitru account !!"
          redirect_to url_for(:action=>:index), :notice=>msg
        else
          msg = "There was an error while transfering funds to Ubitru: #{@transfer.response.message}."
          redirect_to url_for(:action=>:index), :alert=>msg
        end
      else
        #paypal button
        if @transfer.setup_paypal_purchase(confirm_funds_transfer_url(@transfer), url_for(:action=>'index'))
          redirect_to @transfer.paypal_redirect_url
        else
          redirect_to url_for(:action=>'index'), :alert => 'Error occured while trying to prepare funds transfer. Failed connectiong to PayPal. No funds were transfered'
        end
      end
    else
      @refund = current_vendor.funds_refunds.build if current_vendor.balance.to_i > 0
      list_transfers_and_refunds
      render :index
    end
  end
  
  def confirm
    @transfer = current_vendor.funds_transfers.find params[:id]
    if @transfer.paypal_token != params[:token]
      @transfer.update_attribute(:status, 'error_token_mismatch')
      redirect_to url_for(:action=>'index'), :alert=> "Error while processing PayPal response. If the problem persists please contact support. (No funds were transfered)"
    elsif @transfer.ip_address != request.remote_ip
      @transfer.update_attribute(:status, 'error_ip_mismatch')
      redirect_to url_for(:action=>'index'), :alert=> "IP address mismatch!! Looks like youre doing something fishy. If not just try again"
    else
      @transfer.save_paypal_transaction_details
    end
  end
  
  def execute
    @transfer = current_vendor.funds_transfers.find params[:id]
    if @transfer.ip_address != request.remote_ip
      @transfer.update_attribute(:status, 'error_ip_mismatch')
      redirect_to url_for(:action=>'index'), :alert=> "IP address mismatch!! Looks like youre doing something fishy. If not just try again"
    else
      if @transfer.execute
        msg = "Sucessfully transfered #{view_context.format_currency(@transfer.amount)} to your Ubitru account !!"
        redirect_to url_for(:action=>:index), :notice=>msg
      else
        msg = "There was an error while transfering funds to Ubitru. No funds were transfered. Please try again or contact support if the problem persists"
        redirect_to url_for(:action=>:index), :alert => msg
      end
    end
  end
  
  def new_refund
    @refund = current_vendor.funds_refunds.build
  end
  
  def create_refund
    @refund = current_vendor.funds_refunds.build(params[:funds_refund])
    if @refund.save
      if @refund.execute
        redirect_to url_for(:action=>'index'), :notice => "Refund success."
      else
        redirect_to url_for(:action=>'index'), 
          :alert => "There was an error while executing the refund. " +
        "Try again or contact support. (unsettled credit card transfers are only refundable in full - " +
        "no partial refunds, if you want a partial refund you may have to wait couple of days)"
      end
    else
      flash.alert = "Refund saving error."
      @transfer = current_vendor.funds_transfers.build
      list_transfers_and_refunds
      render :index
    end
  end

  
end
