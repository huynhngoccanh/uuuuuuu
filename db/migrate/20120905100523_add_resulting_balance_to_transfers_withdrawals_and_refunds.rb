class AddResultingBalanceToTransfersWithdrawalsAndRefunds < ActiveRecord::Migration
  def up
    add_column :funds_transfers, :resulting_balance, :integer
    add_column :funds_refunds, :resulting_balance, :integer
    add_column :funds_withdrawals, :resulting_balance, :integer
    
    
    transactions = FundsTransfer.find_by_sql("
      (SELECT id, created_at AS performed_at, 'FundsTransfer' AS kind, amount
      FROM funds_transfers WHERE status='success')
      UNION ALL
      (SELECT id, created_at AS performed_at, 'FundsRefund' AS kind, -1 * refunded_amount as amount
      FROM funds_refunds WHERE status IN ('complete', 'partially_complete') )
      UNION ALL
      (SELECT id, created_at AS performed_at, 'FundsWithdrawal' AS kind, -1 * amount as amount
      FROM funds_withdrawals WHERE success=1 )
      
      ORDER BY performed_at ASC
      ")
    current_balance = 0
    transactions.each do |t|
      current_balance += t.amount
       t.kind.constantize.where({:id=>t.id}).update_all({:resulting_balance => current_balance})
    end
  end
  
  def down
    remove_column :funds_transfers, :resulting_balance
    remove_column :funds_refunds, :resulting_balance
    remove_column :funds_withdrawals, :resulting_balance
  end
end
