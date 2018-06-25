class AddMaxCommisionPercentToCjAdvertisers < ActiveRecord::Migration
  def up
    add_column :cj_advertisers, :max_commission_percent, :float
    add_column :cj_advertisers, :max_commission_dollars, :float
  	#   CjAdvertiser.reload_all_advertisers
  end
  
  def down
    remove_column :cj_advertisers, :max_commission_percent
    remove_column :cj_advertisers, :max_commission_dollars
  end
end
