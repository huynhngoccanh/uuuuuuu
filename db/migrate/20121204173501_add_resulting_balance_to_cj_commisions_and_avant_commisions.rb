class AddResultingBalanceToCjCommisionsAndAvantCommisions < ActiveRecord::Migration
  def up
    add_column :cj_commissions, :resulting_balance, :integer
    add_column :avant_commissions, :resulting_balance, :integer
    
    transactions = FundsTransfer.find_by_sql("
      (SELECT id, created_at AS performed_at, 'FundsTransfer' AS kind, amount
      FROM funds_transfers WHERE status='success')
      UNION ALL
      (SELECT id, created_at AS performed_at, 'FundsRefund' AS kind, -1 * refunded_amount as amount
      FROM funds_refunds WHERE status IN ('complete', 'partially_complete') )
      UNION ALL
      (SELECT id, created_at AS performed_at, 'FundsWithdrawal' AS kind, -1 * amount as amount
      FROM funds_withdrawals WHERE success=1 )
      UNION ALL
      (SELECT id, created_at AS performed_at, 'CjCommission' AS kind, ROUND(commission_amount) as amount
      FROM cj_commissions)
      UNION ALL
      (SELECT id, created_at AS performed_at, 'AvantCommission' AS kind, ROUND(commission_amount) as amount
      FROM avant_commissions)
      
      ORDER BY performed_at ASC
      ")
    current_balance = 0
    transactions.each do |t|
      current_balance += t.amount.round
      t.kind.constantize.where({:id=>t.id}).update_all({:resulting_balance => current_balance})
    end
  end
  
  def down
    remove_column :cj_commissions, :resulting_balance
    remove_column :avant_commissions, :resulting_balance
  end
end
