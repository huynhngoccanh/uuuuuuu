class Api::V1::UsersController < Api::V1::ApplicationController
  before_action :find_user, only: [:my_loyalty_programs, :my_loyalty_program_details, :loyalty_programs]
  # All Reward programs 
  def loyalty_programs
    if @user  
      @programs = Merchant.loyalty - @user.loyalty_programs
      if !@programs.blank?
          render json: {
            success: true,
            programs: @programs.as_json({
              only: [:id, :name], 
              methods: [:icon_url]
              })
          }
        else
          render json: {
           success: false,
           message: "At this point we have not any Ubitru Reward Program"
          }
        end
    else
      render json: {
       success: false,
       message: "Ooops! invalid access token"
      }
    end
  end

  # User joined Reward Programs
  def my_loyalty_programs
    if @user
      @user_programs = @user.loyalty_programs
      if params[:q]
        @user_programs = @user.loyalty_programs.order("#{params[:q]} desc")
      end
      render json: {
        success: true,
        programs: @user_programs.as_json({
          only: [:id, :name, :color_palette, :used_counter],
          methods: [:image_url, :icon_url],
        })
      }
    else
      render json: {
       success: false,
       message: "Ooops! invalid access token"
      }
    end
  end

  # Show User Joined program details

  def my_loyalty_program_details
    if @user
      @loyalty_programs_user = @user.loyalty_programs_users.where(loyalty_program_id: params[:loyalty_programs_id]).first 
      @loyalty_programs_user.loyalty_program.increment!(:used_counter)
      render json: {
        success: true,
        programs_details: @loyalty_programs_user.as_json({
          only: [:id, :account_id, :account_number, :points, :status, :num_used],
          include: {
            loyalty_program: {
              only: [:name, :id, :color_palette, :used_counter],
              methods: [:icon_url, :redirection_link]
            }
          },
        })
      }
    else
      render json: {
       success: false,
       message: "Ooops! invalid access token"
      }
    end    
  end

  private

  def find_user
    @user = ApiKey.where(access_token: params[:access_token], expire:true).first.try(:user)
  end


end
