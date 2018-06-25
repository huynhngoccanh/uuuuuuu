class Api::V1::Admin::TaxonsController < Api::V1::Admin::ApplicationController

	before_action :set_taxon, only: [:update]

	def update
		if @taxon.update_attributes(taxon_params)
			render json: @taxon
		else
			render json: {
				success: false,
				message: @taxon.errors.full_messages.join(", ")
			}
		end
	end

	def create
		taxon = Taxon.new(taxon_params)
		if taxon.save
			render json: taxon
		else
			render json: {
				success: false,
				message: taxon.errors.full_messages.join(", ")
			}
		end
	end

	private

	  def set_taxon
	  	@taxon = Taxon.where(id: params[:id]).first
	  end

	  def taxon_params
	  	params.require(:taxon).permit(:id, :name, :taxonomy_id, :parent_id, :in_popular_store, merchant_ids: [])
	  end

end