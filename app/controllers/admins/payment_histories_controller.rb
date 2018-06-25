class Admins::PaymentHistoriesController < Admins::ApplicationController

before_action :set_payment, only: [:show, :edit, :update, :destroy]

  def index
    @payment_history  = PaymentHistory.includes(:user)
  end

  def show
  
  end

  
  def edit
  end


  def update
  
  end


  private
    
    def set_payment
      @payment_history = PaymentHistory.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def payment_params
      params[:merchant].permit!
    end
end