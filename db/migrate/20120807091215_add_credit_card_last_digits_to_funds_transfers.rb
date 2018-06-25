class AddCreditCardLastDigitsToFundsTransfers < ActiveRecord::Migration
  def change
    add_column :funds_transfers, :card_last_digits, :string
  end
end
