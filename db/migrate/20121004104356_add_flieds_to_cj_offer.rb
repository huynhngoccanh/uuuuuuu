class AddFliedsToCjOffer < ActiveRecord::Migration
  def change
    add_column :cj_offers, :expected_commission, :float
    add_column :cj_offers, :commission_payed, :boolean
    add_column :cj_offers,:commission_value, :float
  end
end
