class CreateUserTransactions < ActiveRecord::Migration
  class UserTransaction < ActiveRecord::Base
    belongs_to :user
    belongs_to :transactable, :polymorphic => true

    validates :user, :presence=>true
    validates :user_id, :presence=>true
    validates :transactable, :presence=>true
    validates :transactable_id, :presence=>true

    def self.create_for transactable
      transactable_type = transactable.class.name
      amount = 0
      case transactable_type
        when 'Auction'
          return if !['accepted'].include? transactable.status
          amount = transactable.user_earnings
        when 'FundsWithdrawal'
          return if !transactable.success
          amount = -transactable.amount
        when 'ReferredVisit'
          return if transactable.earnings.nil?
          amount = transactable.earnings
        when 'FundsWithdrawalNotification'
          return if !transactable.funds_withdrawal || !transactable.funds_withdrawal.success
          return if ['Failed','Returned','Reversed'].include?(transactable.status)
          amount = -transactable.funds_withdrawal.amount
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

  def up
    create_table :user_transactions do |t|
      t.integer :user_id
      t.integer :amount
      t.integer :resulting_balance
      t.integer :transactable_id
      t.string :transactable_type
      t.integer :total_amount

      t.timestamps
    end

    #create appropiate transaction records for user
    User.find_each do |u|
      auctions = u.auctions.where(:status=>'accepted').to_a
      withdrawals = u.funds_withdrawals.where(:success=>true).to_a
      referred_visits = u.referred_visits.where('referred_visits.earnings IS NOT NULL').to_a
      failed_withdrawals = u.funds_withdrawals.where(:success=>false).to_a.sum do |withdrawal| 
        withdrawal.notifications.where(:status=>['Failed','Returned','Reversed']).to_a
      end
      failed_withdrawals = failed_withdrawals.is_a?(Array) ? failed_withdrawals : []

      all = auctions + withdrawals + referred_visits + failed_withdrawals
      all.sort_by { |t| t.updated_at}.each do |transactable|
        UserTransaction.create_for transactable
      end
    end
  end

  def down
    drop_table :user_transactions
  end
end
