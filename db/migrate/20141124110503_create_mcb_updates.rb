class CreateMcbUpdates < ActiveRecord::Migration
  def change
    create_table :mcb_updates do |t|
      t.references :user
      t.date :alert_date
      t.integer :alertable_id
      t.string  :alertable_type
      t.timestamps
    end
  end
end
