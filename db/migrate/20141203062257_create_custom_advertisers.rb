class CreateCustomAdvertisers < ActiveRecord::Migration
  def change
    create_table :custom_advertisers do |t|
      t.string :name
      t.string :advertiser_url
      t.boolean :inactive
      t.boolean :mobile_enabled, :default => false
      t.float :max_commission_percent
      t.decimal :max_commission_dollars, :precision => 8, :scale => 2
      t.has_attached_file :logo
      t.timestamps
    end
  end
end
