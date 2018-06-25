class CreateClicks < ActiveRecord::Migration
  def change
    create_table :clicks do |t|
      t.integer  :user_id
      t.integer  :resource_id
      t.string   :resource_type
      t.text     :url
      t.string   :ip
      t.decimal  :cashback_amount,        precision: 10, scale: 2, default: 0
      t.boolean  :eligiable_for_cashback

      t.timestamps null: false
    end
  end
end
