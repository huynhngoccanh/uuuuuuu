class CreateLinkshareAdvertisers < ActiveRecord::Migration
  def change
    create_table :linkshare_advertisers do |t|
      t.string :name
      t.integer :advertiser_id
      t.string :base_offer_id
      t.string :website
      t.decimal :max_commission_percent, :precision => 8, :scale => 2
      t.decimal :max_commission_dollars, :precision => 8, :scale => 2
      t.text :params
      t.boolean :inactive

      t.timestamps
    end
    add_index :linkshare_advertisers, :advertiser_id
  end
end
