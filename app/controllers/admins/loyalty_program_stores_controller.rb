class Admins::LoyaltyProgramStoresController < Admins::ApplicationController

  def index
 
  end

  def import
  if params[:id]=="" || params[:id].nil?
    flash[:alert] = "Please select a loyalty program"
    render action: "index"
  else
  if params[:file].nil?
    flash[:alert] = "Please select a file"
    render action: "index"
  else
        loyalty_program=LoyaltyProgram.find(params[:id])
        Store.import_stores_for_loyalty_program(params[:file], loyalty_program)
        flash[:notice] = "Stores were added sucessfully"
        render action: "index"
  end
  end
  end

 
end