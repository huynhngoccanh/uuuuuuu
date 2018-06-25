class CreateMuddlemeTransactions < ActiveRecord::Migration
  class MuddlemeTransaction < ActiveRecord::Base
    KINDS = ['vendor_bids_without_user_share_add',
      'affiliate_commission_without_user_share_add',
      'affiliate_commission_add',
      'affiliate_commission_substract_user_share',
      'vendor_grant_substract'
    ]

    default_scope {order('muddleme_transactions.created_at, muddleme_transactions.id ASC')}

    belongs_to :transactable, :polymorphic => true

    validates :transactable, :presence=>true
    validates :transactable_id, :presence=>true
    validates :kind, :presence=>true, :inclusion => {:in=>KINDS}

    def self.create_for transactable
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
            amount = transactable.commission_amount.round() - auction.user_earnings
            kind = 'affiliate_commission_without_user_share_add'
          else
            amount = -auction.user_earnings
            kind = 'affiliate_commission_substract_user_share'
          end
        else
          amount = transactable.commission_amount.round()
          kind = 'affiliate_commission_add'
        end
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

  def up
    create_table :muddleme_transactions do |t|
      t.string :kind
      t.integer :amount
      t.integer :resulting_balance
      t.integer :transactable_id
      t.string :transactable_type
      t.integer :total_amount

      t.timestamps
    end

    auctions = Auction.where(:status => "accepted").to_a
    cj_offers = CjCommission.all.to_a
    
    all = auctions + cj_offers
    all.sort_by { |t| t.updated_at}.each do |transactable|
      MuddlemeTransaction.create_for transactable
    end
  end

  def down
    drop_table :muddleme_transactions
  end
end
