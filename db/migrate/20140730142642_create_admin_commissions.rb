class CreateAdminCommissions < ActiveRecord::Migration
  def change
    create_table :admin_commissions do |t|
      t.float :commission_amount
      t.integer :user_id

      t.timestamps
    end
  end
end
