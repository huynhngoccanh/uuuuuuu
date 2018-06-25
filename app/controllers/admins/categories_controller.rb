class Admins::CategoriesController < Admins::ApplicationController

	layout "ubitru_admin"

	def index
	end

	def show
		@taxonomy = Taxonomy.where(id: params[:id]).last
	end

end