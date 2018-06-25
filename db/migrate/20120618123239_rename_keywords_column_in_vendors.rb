class RenameKeywordsColumnInVendors < ActiveRecord::Migration
  def up
    rename_column :vendors, :keywords, :service_provider_keywords
  end

  def down
    rename_column :vendors, :service_provider_keywords, :keywords
  end
end
