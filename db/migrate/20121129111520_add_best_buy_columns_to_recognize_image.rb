class AddBestBuyColumnsToRecognizeImage < ActiveRecord::Migration
  def change
    add_column :recognize_images, :best_buy_id, :string
    add_column :recognize_images, :best_buy_image_url, :string
    add_column :recognize_images, :best_buy_product_name, :string
  end
end
