class RenameCategoryCoulmnInAuctions < ActiveRecord::Migration
  def up
    rename_column :auctions, :category_id, :service_category_id
  end

  def down
    rename_column :auctions, :service_category_id, :category_id
  end
end
