class AddLogoUrlToSearchMerchants < ActiveRecord::Migration
  def change
    add_column :search_merchants, :logo_url, :string
  end
end
