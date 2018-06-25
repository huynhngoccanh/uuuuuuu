class AddHeaderAndImageInPlacements < ActiveRecord::Migration
  def change
  	add_column :placements, :header, :text
  	add_attachment :placements, :image
  end
end
