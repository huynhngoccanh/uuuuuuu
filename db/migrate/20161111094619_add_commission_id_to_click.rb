class AddCommissionIdToClick < ActiveRecord::Migration
  def change
    add_column :clicks, :commissionable_id, :integer
    add_column :clicks, :commissionable_type, :string
    add_column :clicks, :commission_amount, :string
    add_column :clicks, :commissionable_confirm, :string    
  end
end
