class AddInPopularStoreInTaxonomies < ActiveRecord::Migration
  def change
  	add_column :taxons, :in_popular_store, :boolean, default: false
  end
end
