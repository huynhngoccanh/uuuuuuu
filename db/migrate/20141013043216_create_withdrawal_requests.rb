class CreateWithdrawalRequests < ActiveRecord::Migration
  def change
    create_table :withdrawal_requests do |t|
      t.references :user
      t.string :paypal_email
      t.integer :amount
      t.integer :user_balance
      t.timestamps
    end
  end
end
