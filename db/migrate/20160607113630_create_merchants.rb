class CreateMerchants < ActiveRecord::Migration
  def change
    create_table :merchants do |t|
      t.string :name
      t.string :slug
      t.attachment :image

      t.timestamps null: false
    end
  end
end
