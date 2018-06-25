class Admins::WithdrawalRequestsController < Admins::ApplicationController

  def index
    @withdrawal_requests = WithdrawalRequest.paginate(:page=>params[:page], :per_page=>10)
    @total_pp_amount = WithdrawalRequest.sum(:amount)
  end

  def show
    @withdrawal_request = WithdrawalRequest.find(params[:id])
  end

end
