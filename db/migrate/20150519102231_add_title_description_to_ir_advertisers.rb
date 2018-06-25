class AddTitleDescriptionToIrAdvertisers < ActiveRecord::Migration
  def change
    add_column :ir_advertisers, :title, :string
    add_column :ir_advertisers, :description, :string
  end
end
