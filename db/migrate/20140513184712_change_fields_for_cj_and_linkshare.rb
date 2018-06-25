class ChangeFieldsForCjAndLinkshare < ActiveRecord::Migration
  def change
    # add_column :cj_advertisers, :sample_link_id, :string, :after => :advertiser_id

    # add_column :cj_coupons, :ad_id, :string, :after => :advertiser_id
    # add_column :cj_coupons, :ad_url, :string, :after => :ad_id
    # add_column :cj_coupons, :manually_uploaded, :boolean

    add_column :linkshare_coupons, :ad_id, :string, :after => :advertiser_id
    rename_column :linkshare_coupons, :clickurl, :ad_url
    add_column :linkshare_coupons, :manually_uploaded, :boolean

    add_index :cj_coupons, :ad_id, :unique => true
    add_index :cj_coupons, [:advertiser_id, :code], :unique => true

    add_index :linkshare_coupons, :ad_id, :unique => true
  end
end