class AddParamsToSearchMerchants < ActiveRecord::Migration
  def change
    add_column :search_merchants, :params, :text
  end
end
