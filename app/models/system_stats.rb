class SystemStats < ActiveRecord::Base
  validates :name, :uniqueness => true
  
  # @deprecated
  def self.calculate_system_earnings
    earnings = 0
    Auction.where('status = "accepted"').includes('winning_bids').each do |auction|
      earnings += auction.total_earnings - auction.user_earnings
    end
    #auctions earnings from commission
    Auction.includes(:cj_offers=>:commission, :avant_offers=>:commission).
      where('cj_commissions.id IS NOT NULL OR avant_commissions.id IS NOT NULL').each do |auction|
      commission = auction.cj_offers.includes(:commission).where('cj_commissions.id IS NOT NULL').
                  first.commission
      commission = auction.avant_offers.includes(:commission).where('avant_commissions.id IS NOT NULL').
                  first.commission if commission.blank?
      earnings += commission.commission_amount - (auction.status == 'accepted' ? auction.user_earnings : 0)
    end
    earnings -= VendorFundsGrant.sum('amount')
    earnings
  end

  def self.ordered_operations_sql
    "
    (SELECT created_at AS performed_at, IF(use_credit_card, 'cc deposit','paypal deposit') AS kind, amount, resulting_balance,
    'vendor' AS performer_type, vendor_id AS performer_id, 1 as order_same_date
    FROM funds_transfers WHERE status='success')
    UNION ALL
    (SELECT created_at AS performed_at, 'refund' AS kind, refunded_amount as amount, resulting_balance,
    'vendor' AS performer_type, vendor_id AS performer_id, 1 as order_same_date
    FROM funds_refunds WHERE status IN ('complete', 'partially_complete') )
    UNION ALL
    (SELECT created_at AS performed_at, 'withdrawal' AS kind, amount, resulting_balance,
    'user' AS performer_type, user_id AS performer_id, 1 as order_same_date
    FROM funds_withdrawals WHERE success=1 )
    UNION ALL
    (SELECT created_at AS performed_at, 'CJ commission' AS kind, commission_amount as amount, 
      resulting_balance, 'CjOffer' AS performer_type, cj_offer_id AS performer_id, 1 as order_same_date
    FROM cj_commissions)
    UNION ALL
    (SELECT created_at AS performed_at, 'Avant commission' AS kind, commission_amount as amount, 
      resulting_balance, 'AvantOffer' AS performer_type, avant_offer_id AS performer_id, 1 as order_same_date
    FROM avant_commissions)
    UNION ALL
    (SELECT created_at AS performed_at, 'transfer fee' AS kind, amount, 
      resulting_balance, feeable_type AS performer_type, feeable_id AS performer_id, 2 as order_same_date
    FROM transfer_fees)
    "
  end
  
  def self.system_balance
    res = find_by_sql(ordered_operations_sql + "ORDER BY performed_at DESC, order_same_date DESC LIMIT 1").first
    return res.blank? || res.resulting_balance.blank? ? 0 : res.resulting_balance
  end
end
