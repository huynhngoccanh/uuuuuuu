class CreateReferredVisits < ActiveRecord::Migration
  def change
    create_table :referred_visits do |t|
      t.integer :user_id
      t.integer :earnings
      t.timestamps
    end
    
    add_column :users, :referred_visit_id, :integer
  end
end
