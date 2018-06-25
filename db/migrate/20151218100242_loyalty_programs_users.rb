class LoyaltyProgramsUsers < ActiveRecord::Migration
  def change
    create_table :loyalty_programs_users do |t|
      t.integer :loyalty_program_id, index: true
      t.integer :user_id, index: true
    end
  end
  

end
