class AddPjAdvertiserIdToFavoriteAdvertisersTable < ActiveRecord::Migration
  def change
    add_column :favorite_advertisers, :pj_advertiser_id, :integer, :after => :linkshare_advertiser_id
  end
end
