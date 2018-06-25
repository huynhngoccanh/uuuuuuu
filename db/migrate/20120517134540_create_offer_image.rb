class CreateOfferImage < ActiveRecord::Migration
  def change
    create_table :offer_images do |t|
      t.integer :vendor_id
      t.integer :offer_id
      t.has_attached_file :image
      t.timestamps
    end
  end
end
