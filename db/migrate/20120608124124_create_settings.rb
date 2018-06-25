class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.integer :user_id
      t.boolean :initiated_auction_mail
      t.boolean :ended_auction_mail
      t.boolean :bid_mail

      t.timestamps
    end
  end
end
