class AddLastUsedInPlacements < ActiveRecord::Migration
  def change
  	add_column :placements, :last_used, :datetime
  end
end
