class CreateCjAdvertisers < ActiveRecord::Migration
  def change
    create_table :cj_advertisers do |t|
      t.string :name
      t.string :advertiser_id
      t.float :commission_percent
      t.float :commission_dollars
      t.text :params
      t.timestamps
    end
  end
end
