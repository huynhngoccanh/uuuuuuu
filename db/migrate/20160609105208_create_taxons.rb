class CreateTaxons < ActiveRecord::Migration
  def change
    create_table :taxons do |t|
      t.string :name
      t.integer :position
      t.integer :parent_id
      t.string :permalink
      t.integer :taxonomy_id
      t.text :description
      t.string :meta_title
      t.text :meta_description
      t.string :meta_keywords
      t.string :nested_name

      t.timestamps null: false
    end
  end
end
