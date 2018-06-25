class CreateFundsWithdrawalNotifications < ActiveRecord::Migration
  def change
    create_table :funds_withdrawal_notifications do |t|
      t.integer :funds_withdrawal_id
      t.string :status 
      t.string :receiver_email
      t.string :transaction_id
      t.text :params

      t.timestamps
    end
  end
end
