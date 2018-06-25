class AddIconImageToLoyaltyPrograms < ActiveRecord::Migration
  def self.up
   add_attachment :loyalty_programs, :icon_image
  end

  def self.down
    remove_attachment :loyalty_programs, :icon_image
  end
end
