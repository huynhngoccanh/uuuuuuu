class AddUserEarningsToSearchIntents < ActiveRecord::Migration
  def change
    add_column :search_intents, :user_earnings, :decimal, :precision => 8, :scale => 2
  end
end
