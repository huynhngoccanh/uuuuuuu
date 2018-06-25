class InviteUsersController < ApplicationController
 
 def create
    token = generate_token
    @invite_user = InviteUser.new(user_params.merge(user_id: current_user.id, token: token, status: 'Pending'))
    if @invite_user.save
      redirect_to '/referred_visits' , notice: "Invitation Sent"
    else
      redirect_to '/referred_visits', notice: @invite_user.errors.full_messages
    end
  end
  private

  def user_params
    params.require(:invite_user).permit(:email)
  end
  
  def generate_token
    @access_token = (Digest::SHA1.hexdigest "#{Time.now.to_i}#{1}")
      
  end
end
