class CalcUsersBalances < ActiveRecord::Migration
  def up
    User.all.each do |user|
      User.update_all({:balance => user.calculated_balance}, {:id=>user.id})
    end
  end
  
  def down
    
  end
end
