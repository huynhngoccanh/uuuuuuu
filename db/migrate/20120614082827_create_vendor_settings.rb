class CreateVendorSettings < ActiveRecord::Migration
  def change
    create_table :vendor_settings do |t|
      t.integer :vendor_id
      t.boolean :recommended_auctions_mail
      t.boolean :auction_status_mail
      t.boolean :auction_result_mail
      t.boolean :contact_info_mail
      t.boolean :auto_bid_mail

      t.timestamps
    end
  end
end
