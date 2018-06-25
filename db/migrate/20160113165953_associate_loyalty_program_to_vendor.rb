class AssociateLoyaltyProgramToVendor < ActiveRecord::Migration
  def change
    add_column :loyalty_programs, :vendor_id, :integer
    add_index :loyalty_programs, :vendor_id
  end
end
