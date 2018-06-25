class AddIrAdvertiserIdToFavoriteAdvertisersTable < ActiveRecord::Migration
  def change
    add_column :favorite_advertisers, :ir_advertiser_id, :integer, :after => :pj_advertiser_id
  end
end
