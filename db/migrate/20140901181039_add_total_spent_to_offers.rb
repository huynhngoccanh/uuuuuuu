class AddTotalSpentToOffers < ActiveRecord::Migration
  def change
    add_column :offers, :total_spent, :decimal, :precision => 8, :scale => 2
  end
end
