class Admins::BoxMessagesController < Admins::ApplicationController

  def index
    @box_message = Search::BoxMessage.new
  end

  def create
    success = true

    limit_users = 500
    num_users = User.count
    0.step(num_users, limit_users) do |offset|
      break unless success
      users = User.offset(offset).limit(limit_users).to_a
      Search::BoxMessage.transaction do
        users.each do |user|
          box_message = Search::BoxMessage.new params[:search_box_message]
          box_message.user = user
          success = success && box_message.save
          break unless success
        end
      end
    end

    if success
      flash[:notice] = 'Successfully sent.'
    else
      flash[:alert] = "Errors occured. Can't sent."
    end
    redirect_to :action => :index
  end
end
