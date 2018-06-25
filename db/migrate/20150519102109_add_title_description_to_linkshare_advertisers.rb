class AddTitleDescriptionToLinkshareAdvertisers < ActiveRecord::Migration
  def change
    add_column :linkshare_advertisers, :title, :string
    add_column :linkshare_advertisers, :description, :string
  end
end
