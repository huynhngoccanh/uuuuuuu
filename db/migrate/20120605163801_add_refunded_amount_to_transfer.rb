class AddRefundedAmountToTransfer < ActiveRecord::Migration
  def change
    add_column :funds_transfers, :refunded_amount, :integer
  end
end
