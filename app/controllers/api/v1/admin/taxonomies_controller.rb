class Api::V1::Admin::TaxonomiesController < Api::V1::Admin::ApplicationController

	before_action :set_account

	def show
		render json: @taxonomy
	end

	def taxons
		render json: @taxonomy.taxons.where(parent_id: params[:parent_id])
	end

	private

	  def set_account
	  	@taxonomy = Taxonomy.where(id: params[:id]).last
	  end	

end