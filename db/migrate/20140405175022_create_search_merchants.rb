class CreateSearchMerchants < ActiveRecord::Migration
  def up
    create_table :search_merchants do |t|
      t.string :company_name
      t.string :company_address
      t.string :company_url
      t.string :offer_name
      t.string :coupon_code
      t.string :company_phone
      t.string :user_money, :null => false
      t.string :offer_buy_url
      t.string :company_coupons_url
      t.integer :intent_id, :null => false
      t.boolean :active, :default => false
      t.integer :db_id
      t.string :type, :null => false

      t.timestamps
    end
    change_column :search_merchants, :id , 'bigint NOT NULL AUTO_INCREMENT'
    add_index :search_merchants, :intent_id
    add_index :search_merchants, :db_id
  end

  def down
    drop_table :search_merchants
  end
end
