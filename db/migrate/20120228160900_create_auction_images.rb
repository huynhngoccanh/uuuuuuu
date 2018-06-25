class CreateAuctionImages < ActiveRecord::Migration
  def change
    create_table :auction_images do |t|
      t.integer :user_id
      t.integer :auction_id
      t.has_attached_file :image
      t.timestamps
    end
  end
end
