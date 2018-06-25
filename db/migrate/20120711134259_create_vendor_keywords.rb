class CreateVendorKeywords < ActiveRecord::Migration
  def up
    remove_column :vendors, :retailer_keywords
    remove_column :vendors, :service_provider_keywords
    
    create_table :vendor_keywords do |t|
      t.integer :vendor_id
      t.string :keyword
      t.timestamps
    end
  end
  
  def down
    add_column :vendors, :retailer_keywords, :text
    add_column :vendors, :service_provider_keywords, :text
    
    drop_table :vendor_keywords
  end
end
