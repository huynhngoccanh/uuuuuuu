class LoyaltyProgramsUsersController < ApplicationController

  layout "ubitru"
  before_filter :find_loyalty_programs_user

  def edit
  end

   def update
    @loyalty_programs_user = current_user.loyalty_programs_users.find(params[:id])
    if @loyalty_programs_user.update_attributes(loyalty_programs_user_params.merge(exception:nil))
      redirect_to loyalty_result_path, :notice => 'Profile was successfully updated.'
    else
      render :action => "edit"
    end
  end

  

  def destroy
    if @loyalty_programs_user.destroy
      redirect_to :back, flash: {success: "Loyalty Program removed from list"}
    end
  end

  private 

    def find_loyalty_programs_user
      @loyalty_programs_user = current_user.loyalty_programs_users.find(params[:id])
    end

    def loyalty_programs_user_params
      params.require(:loyalty_programs_user).permit(:account_id, :points, :account_number, :status, :password)   
    end

end
