class CreateMerchantTaxons < ActiveRecord::Migration
  def change
    create_table :merchant_taxons do |t|
      t.integer :merchant_id
      t.integer :taxon_id

      t.timestamps null: false
    end
  end
end
