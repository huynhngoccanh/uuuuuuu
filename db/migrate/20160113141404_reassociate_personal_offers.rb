class ReassociatePersonalOffers < ActiveRecord::Migration
  def change
    add_column :personal_offers, :vendor_id, :integer
    add_index :personal_offers, :vendor_id
  end
end
