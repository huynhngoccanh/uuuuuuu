class UserServiceProvidersController < ApplicationController

  def new
    @service_provider = UserServiceProvider.new
    render :layout => "popup"
  end

  def create

  end


end
