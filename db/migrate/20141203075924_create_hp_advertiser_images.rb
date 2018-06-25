class CreateHpAdvertiserImages < ActiveRecord::Migration
  def change
    create_table :hp_advertiser_images do |t|
      t.has_attached_file :hp_image
      t.integer :imageable_id
      t.string  :imageable_type
      t.timestamps
    end
  end
end
