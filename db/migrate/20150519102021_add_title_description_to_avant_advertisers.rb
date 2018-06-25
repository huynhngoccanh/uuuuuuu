class AddTitleDescriptionToAvantAdvertisers < ActiveRecord::Migration
  def change
    add_column :avant_advertisers, :title, :string
    add_column :avant_advertisers, :description, :string
  end
end
