class AddPolimorphicAssociationInHpStores < ActiveRecord::Migration
  def change
  	add_column :hp_stores, :advertiser_id, :integer
  	add_column :hp_stores, :advertiser_type, :string
  end
end
