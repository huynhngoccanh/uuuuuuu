class ChangeParamsColumnTypeInPjAdvertisersTable < ActiveRecord::Migration
  def up
    change_column :pj_advertisers, :params, :text, :limit => 4294967295
  end

  def down
    change_column :pj_advertisers, :params, :text, :limit => 65535
  end
end
