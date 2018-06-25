class AddOtherDbIdToSearchMerchants < ActiveRecord::Migration
  def change
    add_column :search_merchants, :other_db_id, :integer, :after => :db_id
  end
end
