class CreatePjAdvertisers < ActiveRecord::Migration
  def change
    create_table :pj_advertisers do |t|
      t.string :name
      t.string :advertiser_id
      t.boolean :inactive
      t.text :params
      t.boolean :mobile_enabled, :default => false
      t.float :max_commission_percent
      t.decimal :max_commission_dollars, :precision => 8, :scale => 2
      t.string :generic_link
      t.has_attached_file :logo
      t.timestamps
    end
  end
end
