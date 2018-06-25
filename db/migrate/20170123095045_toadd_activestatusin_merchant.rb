class ToaddActivestatusinMerchant < ActiveRecord::Migration
  def change
		add_column :merchants,:active_status, :boolean, default:false  
  end
end
