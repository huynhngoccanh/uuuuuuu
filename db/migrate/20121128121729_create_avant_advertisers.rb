class CreateAvantAdvertisers < ActiveRecord::Migration
  def change
    create_table :avant_advertisers do |t|
      t.string :name
      t.string :advertiser_id
      t.string :advertiser_url
      t.float :commission_percent
      t.float :commission_dollars
      t.text :params
      t.has_attached_file :logo
      t.boolean :inactive

      t.timestamps
    end
  end
end
