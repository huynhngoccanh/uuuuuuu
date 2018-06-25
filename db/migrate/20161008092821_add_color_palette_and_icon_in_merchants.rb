class AddColorPaletteAndIconInMerchants < ActiveRecord::Migration
  def change
  	add_column :merchants, :color_palette, :string, default: "#eeeeee"
  	add_attachment :merchants, :icon
  end
end
