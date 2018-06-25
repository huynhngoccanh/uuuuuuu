class MergeAdvertisersWithMerchants < ActiveRecord::Migration
  def change
  	add_column :avant_advertisers, :merchant_id, :integer
  	add_column :cj_advertisers, :merchant_id, :integer
  	add_column :linkshare_advertisers, :merchant_id, :integer
  	add_column :pj_advertisers, :merchant_id, :integer
  	add_column :ir_advertisers, :merchant_id, :integer
  end
end
