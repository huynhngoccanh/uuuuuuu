class AddServiceTypeIndexToOffers < ActiveRecord::Migration
  def change
     add_index :offers, :service_type
  end
end
