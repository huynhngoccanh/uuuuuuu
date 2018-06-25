class CreateFacebookqueries < ActiveRecord::Migration
  def change
    create_table :facebookqueries do |t|
      t.string :facebook_uid
      t.string :query 
      t.timestamps null: false
    end
  end
end
