class AddFallbackLinkInMerchants < ActiveRecord::Migration
  def change
  	add_column :merchants, :fallback_link, :text
  end
end
