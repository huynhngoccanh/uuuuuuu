class AddAttachmentAvatarToLoyaltyProgramCoupon < ActiveRecord::Migration
   def self.up
   add_attachment :loyalty_program_coupons, :barcode_image
  end

  def self.down
    remove_attachment :loyalty_program_coupons, :barcode_image
  end
end
