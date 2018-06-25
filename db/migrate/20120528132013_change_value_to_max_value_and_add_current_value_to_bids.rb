class ChangeValueToMaxValueAndAddCurrentValueToBids < ActiveRecord::Migration
  class Bid < ActiveRecord::Base
    belongs_to :auction
    
    def calc_current_value
      max_vendors = auction.max_vendors 
      if auction.bids.count > max_vendors
        highest_bids = auction.bids.order('max_value DESC, updated_at ASC').offset(max_vendors-1).limit(2)
        lowest_above_treshold = highest_bids.first.max_value
        highest_below_treshlod = highest_bids.second.max_value
        [lowest_above_treshold, highest_below_treshlod + value_step, max_value].min
      else
        minimum_value
      end
    end
    
    def minimum_value
      6
    end

    def value_step
      1
    end
  end
  
  
  def up
    add_column :bids, :current_value, :integer
    rename_column :bids, :value, :max_value
    rename_column :archived_bids, :value, :max_value
    
    Bid.reset_column_information
    Bid.all.each do |bid|
       Bid.where({:id=>bid.id}).update_all({:current_value=> bid.calc_current_value})
    end
  end
  
  def down
    remove_column :bids, :current_value
    rename_column :bids, :max_value, :value
    rename_column :archived_bids, :max_value, :value
  end
end
