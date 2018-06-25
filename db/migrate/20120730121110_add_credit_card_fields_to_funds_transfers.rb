class AddCreditCardFieldsToFundsTransfers < ActiveRecord::Migration
  def change
    add_column :funds_transfers, :use_credit_card, :boolean
    add_column :funds_transfers, :card_type, :string
    add_column :funds_transfers, :card_first_name, :string
    add_column :funds_transfers, :card_last_name, :string
  end
end
