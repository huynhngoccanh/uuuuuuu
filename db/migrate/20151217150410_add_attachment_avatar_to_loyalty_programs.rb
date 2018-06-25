class AddAttachmentAvatarToLoyaltyPrograms < ActiveRecord::Migration
  def self.up
   add_attachment :loyalty_programs, :logo_image
  end

  def self.down
    remove_attachment :loyalty_programs, :logo_image
  end
end
