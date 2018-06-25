class UserTransaction < ActiveRecord::Base
  belongs_to :user
  belongs_to :transactable, :polymorphic => true

  validates :user, :presence=>true
  validates :user_id, :presence=>true
  validates :transactable, :presence=>true
  validates :transactable_id, :presence=>true

  before_update {raise ActiveRecord::ReadOnlyRecord}
  before_destroy {raise ActiveRecord::ReadOnlyRecord}

  def self.create_for transactable
    transactable_type = transactable.class.name
    amount = 0
    case transactable_type
      when 'Auction'
        return if !['accepted'].include? transactable.status
        amount = transactable.user_earnings

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
        return unless transactable.user_transaction.blank?
        amount = transactable.user_earnings
      when 'FundsWithdrawal'
        return if !transactable.success
        amount = -transactable.amount
      when 'ReferredVisit'
        return if transactable.earnings.nil?
        amount = transactable.earnings
      when 'AdminCommission'
        return if transactable.commission_amount.nil?
        amount = transactable.commission_amount
      when 'Search::Intent'
        amount = transactable.user_earnings
      when 'FundsWithdrawalNotification'
        return if !transactable.funds_withdrawal || !transactable.funds_withdrawal.success
        return if !['Failed','Returned','Reversed'].include?(transactable.status)
        amount = transactable.funds_withdrawal.amount
        user = transactable.funds_withdrawal.user
    end
    user ||= transactable.user
    last_transaction = user.transactions.last
    last_this_type_transaction = user.transactions.where(:transactable_type=>transactable_type).last

    self.create!({
      :user=>user,
      :transactable=>transactable,
      :amount=>amount,
      :total_amount=> amount + (last_this_type_transaction.nil? ? 0 : last_this_type_transaction.total_amount),
      :resulting_balance => amount + (last_transaction.nil? ? 0 : last_transaction.resulting_balance)
    })
  end
end
