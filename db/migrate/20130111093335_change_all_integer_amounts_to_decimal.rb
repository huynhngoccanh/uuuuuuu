class ChangeAllIntegerAmountsToDecimal < ActiveRecord::Migration
  def up
    change_column :archived_bids, :max_value, :decimal, :precision => 8, :scale => 2

    change_column :auctions, :user_earnings, :decimal, :precision => 8, :scale => 2

    change_column :avant_advertisers, :commission_percent, :decimal, :precision => 8, :scale => 2
    change_column :avant_advertisers, :commission_dollars, :decimal, :precision => 8, :scale => 2

    change_column :avant_commissions, :price, :decimal, :precision => 8, :scale => 2
    change_column :avant_commissions, :commission_amount, :decimal, :precision => 8, :scale => 2
    change_column :avant_commissions, :resulting_balance, :decimal, :precision => 8, :scale => 2

    change_column :avant_offers, :price, :decimal, :precision => 8, :scale => 2
    change_column :avant_offers, :commission_percent, :decimal, :precision => 8, :scale => 2
    change_column :avant_offers, :commission_dollars, :decimal, :precision => 8, :scale => 2

    change_column :bids, :max_value, :decimal, :precision => 8, :scale => 2

    change_column :campaigns, :max_bid, :decimal, :precision => 8, :scale => 2
    change_column :campaigns, :budget, :decimal, :precision => 8, :scale => 2
    change_column :campaigns, :total_spent, :decimal, :precision => 8, :scale => 2

    # change_column :cj_advertisers, :commission_percent, :decimal, :precision => 8, :scale => 2
    # change_column :cj_advertisers, :commission_dollars, :decimal, :precision => 8, :scale => 2
    # change_column :cj_advertisers, :max_commission_dollars, :decimal, :precision => 8, :scale => 2
    # change_column :cj_advertisers, :max_commission_dollars, :decimal, :precision => 8, :scale => 2

    change_column :cj_commissions, :price, :decimal, :precision => 8, :scale => 2
    change_column :cj_commissions, :commission_amount, :decimal, :precision => 8, :scale => 2
    change_column :cj_commissions, :resulting_balance, :decimal, :precision => 8, :scale => 2

    change_column :cj_offers, :price, :decimal, :precision => 8, :scale => 2
    change_column :cj_offers, :expected_commission, :decimal, :precision => 8, :scale => 2
    change_column :cj_offers, :commission_value, :decimal, :precision => 8, :scale => 2

    change_column :funds_refunds, :requested_amount, :decimal, :precision => 8, :scale => 2
    change_column :funds_refunds, :refunded_amount, :decimal, :precision => 8, :scale => 2
    change_column :funds_refunds, :resulting_balance, :decimal, :precision => 8, :scale => 2

    change_column :funds_transfer_transactions, :amount, :decimal, :precision => 8, :scale => 2

    change_column :funds_transfers, :amount, :decimal, :precision => 8, :scale => 2
    change_column :funds_transfers, :refunded_amount, :decimal, :precision => 8, :scale => 2
    change_column :funds_transfers, :resulting_balance, :decimal, :precision => 8, :scale => 2

    change_column :funds_withdrawals, :amount, :decimal, :precision => 8, :scale => 2
    change_column :funds_withdrawals, :resulting_balance, :decimal, :precision => 8, :scale => 2

    change_column :muddleme_transactions, :amount, :decimal, :precision => 8, :scale => 2
    change_column :muddleme_transactions, :resulting_balance, :decimal, :precision => 8, :scale => 2
    change_column :muddleme_transactions, :total_amount, :decimal, :precision => 8, :scale => 2

    change_column :system_stats, :value, :decimal, :precision => 8, :scale => 2

    change_column :user_transactions, :amount, :decimal, :precision => 8, :scale => 2
    change_column :user_transactions, :resulting_balance, :decimal, :precision => 8, :scale => 2
    change_column :user_transactions, :total_amount, :decimal, :precision => 8, :scale => 2

    change_column :users, :balance, :decimal, :precision => 8, :scale => 2

    change_column :vendor_funds_grants, :amount, :decimal, :precision => 8, :scale => 2

    change_column :vendor_transactions, :amount, :decimal, :precision => 8, :scale => 2
    change_column :vendor_transactions, :resulting_balance, :decimal, :precision => 8, :scale => 2
    change_column :vendor_transactions, :total_amount, :decimal, :precision => 8, :scale => 2

    change_column :vendors, :balance, :decimal, :precision => 8, :scale => 2
  end

  def down
    change_column :archived_bids, :max_value, :integer

    change_column :auctions, :user_earnings, :integer

    change_column :avant_advertisers, :commission_percent, :float
    change_column :avant_advertisers, :commission_dollars, :float

    change_column :avant_commissions, :price, :float
    change_column :avant_commissions, :commission_amount, :float
    change_column :avant_commissions, :resulting_balance, :integer

    change_column :avant_offers, :price, :float
    change_column :avant_offers, :commission_percent, :float
    change_column :avant_offers, :commission_dollars, :float

    change_column :bids, :max_value, :integer

    change_column :campaigns, :max_bid, :decimal, :precision => 8, :scale => 2
    change_column :campaigns, :budget, :integer
    change_column :campaigns, :total_spent, :integer

    change_column :cj_advertisers, :commission_percent, :float
    change_column :cj_advertisers, :commission_dollars, :float
    change_column :cj_advertisers, :max_commission_dollars, :float
    change_column :cj_advertisers, :max_commission_dollars, :float

    change_column :cj_commissions, :price, :float
    change_column :cj_commissions, :commission_amount, :float
    change_column :cj_commissions, :resulting_balance, :integer

    change_column :cj_offers, :price, :float
    change_column :cj_offers, :expected_commission, :float
    change_column :cj_offers, :commission_value, :float

    change_column :funds_refunds, :requested_amount, :integer
    change_column :funds_refunds, :refunded_amount, :integer
    change_column :funds_refunds, :resulting_balance, :integer

    change_column :funds_transfer_transactions, :amount, :integer

    change_column :funds_transfers, :amount, :integer
    change_column :funds_transfers, :refunded_amount, :integer
    change_column :funds_transfers, :resulting_balance, :integer

    change_column :funds_withdrawals, :amount, :integer
    change_column :funds_withdrawals, :resulting_balance, :integer

    change_column :muddleme_transactions, :amount, :integer
    change_column :muddleme_transactions, :resulting_balance, :integer
    change_column :muddleme_transactions, :total_amount, :integer

    change_column :system_stats, :value, :integer

    change_column :user_transactions, :amount, :integer
    change_column :user_transactions, :resulting_balance, :integer
    change_column :user_transactions, :total_amount, :integer

    change_column :users, :balance, :integer

    change_column :vendor_funds_grants, :amount, :integer

    change_column :vendor_transactions, :amount, :integer
    change_column :vendor_transactions, :resulting_balance, :integer
    change_column :vendor_transactions, :total_amount, :integer

    change_column :vendors, :balance, :integer
  end
end
