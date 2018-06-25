class MuddlemeTransaction < ActiveRecord::Base
  KINDS = ['vendor_bids_without_user_share_add',
    'affiliate_commission_without_user_share_add',
    'search_affiliate_commission_without_user_share_add',
    'search_affiliate_substract_referred_visit',
    'affiliate_commission_add',
    'affiliate_commission_substract_user_share',
    'vendor_grant_substract',
    'admin_commission_substract'
  ]

  default_scope -> {order('muddleme_transactions.created_at, muddleme_transactions.id ASC')}

  belongs_to :transactable, :polymorphic => true

  validates :transactable, :presence=>true
  validates :transactable_id, :presence=>true
  validates :kind, :presence=>true, :inclusion => {:in=>KINDS}

  before_update {raise ActiveRecord::ReadOnlyRecord}
  before_destroy {raise ActiveRecord::ReadOnlyRecord}

  def self.earnings
    last.nil? ? 0 : last.resulting_balance
  end

  def self.create_for(transactable, no_user_share = false)
    transactable_type = transactable.class.name
    amount = 0
    case transactable_type
      when 'Auction'
        return if !['accepted'].include? transactable.status
        amount = transactable.total_earnings - transactable.user_earnings
        kind = 'vendor_bids_without_user_share_add'
      when 'CjCommission', 'AvantCommission'
        if transactable_type == 'CjCommission'
          return if transactable.cj_offer.blank? || transactable.cj_offer.auction.blank?
          auction = transactable.cj_offer.auction
        end
        if transactable_type == 'AvantCommission'
          return if transactable.avant_offer.blank? || transactable.avant_offer.auction.blank?
          auction = transactable.avant_offer.auction
        end

        return if !['confirmed', 'accepted', 'rejected'].include?(auction.status)
        if auction.status == 'accepted'
          if transactable.muddleme_transactions.blank?
            #right now just needed for migration
            #when no affiliate_commission_add if already present for this affiliate_commission
            amount = transactable.commission_amount - auction.user_earnings
            kind = 'affiliate_commission_without_user_share_add'
          else
            amount = -auction.user_earnings
            kind = 'affiliate_commission_substract_user_share'
          end
        else
          amount = transactable.commission_amount
          kind = 'affiliate_commission_add'
        end
      when 'VendorFundsGrant'
        amount = -transactable.amount
        kind = 'vendor_grant_substract'

      # search intent stuff
    when 'Search::CjCommission', 'Search::AvantCommission', 'Search::LinkshareCommission', 'Search::PjCommission', 'Search:IrCommission'
        if transactable_type == 'Search::CjCommission'
          return if transactable.cj_merchant.blank? || transactable.cj_merchant.intent.blank?
          intent = transactable.cj_merchant.intent
        end
        if transactable_type == 'Search::AvantCommission'
          return if transactable.avant_merchant.blank? || transactable.avant_merchant.intent.blank?
          intent = transactable.avant_merchant.intent
        end
        if transactable_type == 'Search::LinkshareCommission'
          return if transactable.linkshare_merchant.blank? || transactable.linkshare_merchant.intent.blank?
          intent = transactable.linkshare_merchant.intent
        end
        if transactable_type == 'Search::PjCommission'
          return if transactable.pj_merchant.blank? || transactable.pj_merchant.intent.blank?
          intent = transactable.pj_merchant.intent
        end

        if transactable_type == 'Search::IrCommission'
          return if transactable.ir_merchant.blank? || transactable.ir_merchant.intent.blank?
          intent = transactable.ir_merchant.intent
        end

        return if !['confirmed'].include?(intent.status)
        return unless transactable.muddleme_transaction.blank?
        amount = no_user_share ? transactable.commission_amount : transactable.muddleme_earnings
        kind = 'search_affiliate_commission_without_user_share_add'
      when 'ReferredVisit'
        return if transactable.earnings.nil?
        amount = -transactable.earnings
        kind = 'search_affiliate_substract_referred_visit'
      when 'AdminCommission'
        return if transactable.commission_amount.nil?
        amount = -transactable.commission_amount
        kind = 'admin_commission_substract'
    end
    last_transaction = self.last
    last_this_type_transaction = self.where(:kind=>kind).last

    self.create!({
      :kind => kind,
      :transactable=>transactable,
      :amount=>amount,
      :total_amount=> amount + (last_this_type_transaction.nil? ? 0 : last_this_type_transaction.total_amount),
      :resulting_balance => amount + (last_transaction.nil? ? 0 : last_transaction.resulting_balance)
    })
  end
end
