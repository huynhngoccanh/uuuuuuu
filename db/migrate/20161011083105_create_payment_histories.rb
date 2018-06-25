class CreatePaymentHistories < ActiveRecord::Migration
  def change
    create_table :payment_histories do |t|
      t.integer :user_id
      t.datetime :requested_date
      t.decimal :amount, precision: 10, scale: 2
      t.datetime :paid_on
      t.string :transaction_id
      t.string :paypal_email

      t.timestamps null: false
    end
  end
end
