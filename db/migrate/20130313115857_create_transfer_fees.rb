class CreateTransferFees < ActiveRecord::Migration
  def up
    create_table :transfer_fees do |t|
      t.integer :feeable_id
      t.string :feeable_type
      t.decimal :amount, :precision => 8, :scale => 2
      t.decimal :resulting_balance, :precision => 8, :scale => 2

      t.timestamps
    end

    FundsTransfer.all.each do |transfer|
      fee = TransferFee.create_for transfer
      next unless fee
       TransferFee.where({:id=>fee.id}).update_all({
        :created_at=>transfer.created_at,
        :updated_at=>transfer.updated_at 
        })
    end
    FundsWithdrawal.all.each do |withdrawal|
      fee = TransferFee.create_for withdrawal
      next unless fee
       TransferFee.where({:id=>fee.id}).update_all({
        :created_at=>withdrawal.created_at,
        :updated_at=>withdrawal.updated_at 
        })
    end

    transactions = FundsTransfer.find_by_sql("
      (SELECT id, created_at AS performed_at, 'FundsTransfer' AS kind, amount, 1 as order_same_date
      FROM funds_transfers WHERE status='success')
      UNION ALL
      (SELECT id, created_at AS performed_at, 'FundsRefund' AS kind, -1.0 * refunded_amount as amount, 1 as order_same_date
      FROM funds_refunds WHERE status IN ('complete', 'partially_complete') )
      UNION ALL
      (SELECT id, created_at AS performed_at, 'FundsWithdrawal' AS kind, -1.0 * amount as amount, 1 as order_same_date
      FROM funds_withdrawals WHERE success=1 )
      UNION ALL
      (SELECT id, created_at AS performed_at, 'CjCommission' AS kind, commission_amount as amount, 1 as order_same_date
      FROM cj_commissions)
      UNION ALL
      (SELECT id, created_at AS performed_at, 'AvantCommission' AS kind, commission_amount as amount, 1 as order_same_date
      FROM avant_commissions)
      UNION ALL
      (SELECT id, created_at AS performed_at, 'TransferFee' AS kind, -1.0 * amount, 2 as order_same_date
      FROM transfer_fees)
      ORDER BY performed_at, order_same_date ASC
      ")
    current_balance = 0
    transactions.each do |t|
      current_balance += t.amount
     t.kind.constantize.where({:id=>t.id}).update_all({:resulting_balance => current_balance})
    end
  end

  def down
    drop_table :transfer_fees
  end
end
