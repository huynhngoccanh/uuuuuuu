class CreateSystemStats < ActiveRecord::Migration
  def up
    create_table :system_stats do |t|
      t.string :name
      t.integer :value

      t.timestamps
    end
    
    #SystemStats.create(:name=>'system_earnings', :value=>SystemStats.calculate_system_earnings)
  end
  
  def down
    drop_table :system_stats
  end
end
