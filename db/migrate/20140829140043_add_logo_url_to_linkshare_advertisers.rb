class AddLogoUrlToLinkshareAdvertisers < ActiveRecord::Migration
  def change
    add_column :linkshare_advertisers, :logo_url, :string
  end
end
