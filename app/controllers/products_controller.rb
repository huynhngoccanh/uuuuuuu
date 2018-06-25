class ProductsController < ApplicationController

	def index
		@taxon = Taxon.where(nested_name: params[:id])
		
		@taxons = @taxon.first.taxons + @taxon 
		@merchants = []
		@taxons.each do |e|
			if !e.merchants.blank?
				@merchants += e.merchants
			end
		end

		render :layout => "ubitru"
	end
end
