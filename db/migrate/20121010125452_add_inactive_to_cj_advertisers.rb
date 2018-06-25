class AddInactiveToCjAdvertisers < ActiveRecord::Migration
  def change
    add_column :cj_advertisers, :inactive, :boolean
  end
end
