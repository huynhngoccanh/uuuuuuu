class CreateAuctionOutcomes < ActiveRecord::Migration
  def change
    create_table :auction_outcomes do |t|
      t.integer :auction_id
      t.boolean :purchase_made
      t.datetime :confirmed_at
      t.datetime :first_reminder_sent_at
      t.datetime :second_reminder_sent_at
      t.text :comment

      t.timestamps
    end
  end
end
