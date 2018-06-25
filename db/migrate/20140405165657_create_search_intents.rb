class CreateSearchIntents < ActiveRecord::Migration
   def up
     create_table :search_intents do |t|
     t.string :search, :null => false
       t.integer :user_id, :null => false
       t.date :search_date, :null => false
       t.string :status

       t.timestamps
     end
     change_column :search_intents, :id , 'bigint NOT NULL AUTO_INCREMENT'
     add_index :search_intents, [:search, :user_id, :search_date], :unique => true
     add_index :search_intents, :user_id
     add_index :search_intents, :search
   end

   def down
     drop_table :search_intents
   end
end
