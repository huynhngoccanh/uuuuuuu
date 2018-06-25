class AddTitleToHpAdvertiserImage < ActiveRecord::Migration
  def change
    add_column :hp_advertiser_images, :title, :string
  end
end
