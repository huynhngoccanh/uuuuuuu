class CreateCampaignsZipCodes < ActiveRecord::Migration
  def change
    create_table :campaigns_zip_codes do |t|
      t.integer  :campaign_id
      t.integer  :zip_code_id
      t.timestamps
    end
  end
end
