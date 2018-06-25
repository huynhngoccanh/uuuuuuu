class AddZipCodeAndZipCodeMilesRadiusToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :zip_code, :string
    add_column :campaigns, :zip_code_miles_radius, :integer
  end
end
