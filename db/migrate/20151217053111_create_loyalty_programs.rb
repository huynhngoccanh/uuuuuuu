class CreateLoyaltyPrograms < ActiveRecord::Migration
  def change
    create_table :loyalty_programs do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
