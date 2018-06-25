class AssociateCampaigns < ActiveRecord::Migration
   def change
    add_column :campaigns, :loyalty_program_offer_id, :integer
    add_index :campaigns, :loyalty_program_offer_id
  end
end
