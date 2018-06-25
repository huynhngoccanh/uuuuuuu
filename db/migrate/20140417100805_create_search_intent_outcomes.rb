class CreateSearchIntentOutcomes < ActiveRecord::Migration
  def change
    create_table :search_intent_outcomes do |t|
      t.integer :intent_id
      t.integer :merchant_id
      t.boolean :purchase_made
      t.datetime :confirmed_at
      t.datetime :first_reminder_sent_at
      t.datetime :second_reminder_sent_at
      t.text :comment

      t.timestamps
    end
  end
end
