class AddBalanceToVendor < ActiveRecord::Migration
  class Vendor < ActiveRecord::Base
    has_many :funds_transfers, :dependent=>:restrict_with_error
    has_many :bids
    
    def calculated_balance
      balance = 0
      funds_transfers.where(:status=>:success).each do |transfer|
        balance += transfer.amount
      end
      bids.where(:is_winning=>true).each do |bid|
        balance -= bid.current_value
      end
      balance
    end
  end
  
  def up
    add_column :vendors, :balance, :integer
    
    Vendor.reset_column_information
    Vendor.all.each do |vendor|
      Vendor.update_all({:balance => vendor.calculated_balance}, {:id=>vendor.id})
    end
  end
  
  def down
    remove_column :vendors, :balance
  end
end
