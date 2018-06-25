class Api::V1::Admin::UsersController < Api::V1::Admin::ApplicationController
  def index
    render json: User.all
  end
end
