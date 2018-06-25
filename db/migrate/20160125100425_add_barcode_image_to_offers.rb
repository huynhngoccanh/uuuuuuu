class AddBarcodeImageToOffers < ActiveRecord::Migration
   def self.up
   add_attachment :offers, :barcode_image
  end

  def self.down
    remove_attachment :offers, :barcode_image
  end
end
