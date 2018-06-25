class AddTitleDescriptionToCustomAdvertisers < ActiveRecord::Migration
  def change
    add_column :custom_advertisers, :title, :string
    add_column :custom_advertisers, :description, :string
  end
end
