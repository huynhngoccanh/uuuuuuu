class ModifyOffers < ActiveRecord::Migration
  def up
    remove_column :offers, :coupon_description
    
    add_column :offers, :is_deleted, :boolean, :default=>false
  end

  def down
    add_column :offers, :coupon_description, :text
    
    remove_column :offers, :is_deleted
  end
end
