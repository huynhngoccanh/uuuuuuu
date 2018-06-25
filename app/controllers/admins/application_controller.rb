class Admins::ApplicationController < ActionController::Base

	before_action :check_admin
	layout "ubitru_admin"

	def check_admin
		if current_admin.blank? 
			redirect_to root_path, notice: "Unauthorized access !"
		end
	end

end