class CreateVendorTrackingEvents < ActiveRecord::Migration
  def change
    create_table :vendor_tracking_events do |t|
      t.integer :vendor_id
      t.integer :auction_id
      t.string :event_type
      t.timestamps
    end
  end
end
