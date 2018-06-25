class CreateFundsTransferTransactions < ActiveRecord::Migration
  def change
    create_table :funds_transfer_transactions do |t|
      t.integer :funds_transfer_id
      t.string :action
      t.integer :amount
      t.boolean :success
      t.string :authorization
      t.string :message
      t.text :params

      t.timestamps
    end
  end
end
