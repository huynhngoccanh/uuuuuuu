class AddEarningsToAuction < ActiveRecord::Migration
  def up
    add_column :auctions, :user_earnings, :integer
    
    Auction.reset_column_information
    Auction.all.each do |auction|
       Auction.where({:id=>auction.id}).update_all({:user_earnings => auction.calculate_user_earnings})
    end
  end
  
  def down
    remove_column :auctions, :user_earnings
  end
end
