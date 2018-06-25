class CreateCampaigns < ActiveRecord::Migration
  def change
    create_table :campaigns do |t|
      t.string :name
      t.integer :vendor_id
      t.boolean :product_campaign, :default=>false
      t.integer :duration
      t.integer :min_budget
      t.boolean :limit_vendors, :default=>true
      t.integer :min_vendors
      t.integer :max_vendors
      t.datetime :desired_time
      t.datetime :desired_time_to
      t.string :score
      t.integer :max_bid
      t.integer :max_per_month
      t.text :keywords
      t.text :adwords

      t.timestamps
    end
  end
end
