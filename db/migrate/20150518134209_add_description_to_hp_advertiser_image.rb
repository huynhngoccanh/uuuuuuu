class AddDescriptionToHpAdvertiserImage < ActiveRecord::Migration
  def change
    add_column :hp_advertiser_images, :description, :string
  end
end
