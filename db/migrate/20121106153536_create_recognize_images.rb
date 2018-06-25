class CreateRecognizeImages < ActiveRecord::Migration
  def change
    create_table :recognize_images do |t|
      t.integer :etilize_id
      t.string :etilize_image_type

      t.timestamps
    end
  end
end
