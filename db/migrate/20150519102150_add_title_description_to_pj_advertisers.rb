class AddTitleDescriptionToPjAdvertisers < ActiveRecord::Migration
  def change
    add_column :pj_advertisers, :title, :string
    add_column :pj_advertisers, :description, :string
  end
end
