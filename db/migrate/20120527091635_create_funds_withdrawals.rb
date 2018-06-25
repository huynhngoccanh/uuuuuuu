class CreateFundsWithdrawals < ActiveRecord::Migration
  def change
    create_table :funds_withdrawals do |t|
      t.integer :user_id
      t.integer :amount
      t.string :paypal_email
      #active_merchant details:
      t.boolean :success
      t.string :authorization
      t.string :message
      t.text :params
      
      t.timestamps
    end
  end
end
