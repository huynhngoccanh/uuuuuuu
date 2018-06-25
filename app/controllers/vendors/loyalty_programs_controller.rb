class Vendors::LoyaltyProgramsController < ApplicationController
  def edit
  end
  def update
    loyalty_program=LoyaltyProgram.find(params[:loyalty_program])
    current_vendor.loyalty_program=loyalty_program
    current_vendor.dont_require_password_confirmation=true
    current_vendor.dont_require_password=true
    current_vendor.save
    redirect_to "/", notice: "Loyalty Program Added"
  end 
end
