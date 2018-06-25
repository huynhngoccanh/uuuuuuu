class Search::LinkshareCommission < ActiveRecord::Base
  belongs_to :linkshare_merchant
  has_one :muddleme_transaction, :as => :transactable, :dependent => :destroy
  has_one :user_transaction, :as => :transactable, :dependent => :destroy
  serialize :params

  after_create :close_search_intent_and_pay_commission
  after_create :upadte_click_commission

  before_update { raise ActiveRecord::ReadOnlyRecord }
  before_destroy { raise ActiveRecord::ReadOnlyRecord }

  def set_attributes_from_response_row(row)
    self.price = row[:price]
    self.commission_amount = row[:commission]
    self.search_intent_id_received = row[:search_intent_id_received]
    self.occurred_at = row[:transaction_date]
    self.commission_id = row[:linkshare_order_id]
    self.resulting_balance = SystemStats.system_balance + self.commission_amount

    search_intent = Search::Intent.find_by_id search_intent_id_received
    return nil unless search_intent

    linkshare_advertiser = LinkshareAdvertiser.find_by_advertiser_id(row[:advertiser_id])
    return nil unless linkshare_advertiser

    linkshare_merchant_found = search_intent.merchants.where(:db_id => linkshare_advertiser.id).first
    return nil unless linkshare_merchant_found

    self.linkshare_merchant = linkshare_merchant_found
    self
  end

  def self.fetch_new_commissions
    response = Linkshare.commission_details
    orders_array = []

    # make array one row per order (linkshare respond one order per product)
    response.drop(1).each do |row|
      order_data = {:search_intent_id_received => row[0], :advertiser_id => row[1], :linkshare_order_id => row[3], :transaction_date => Time.parse(row[4] + ' ' + row[5]), :price => row[7].to_f, :commission => row[9].to_f}
      same_order = orders_array.find { |item| item[:linkshare_order_id] == row[3] }
      if same_order
        same_order[:price] += row[7].to_f
        same_order[:commission] += row[9].to_f
      else
        orders_array << order_data
      end
    end

    orders_array.each do |row|
      next if self.find_by_commission_id row[:linkshare_order_id]
      new_comission = self.new.set_attributes_from_response_row(row)
      new_comission.save! unless new_comission.nil?
    end
  end

  def muddleme_earnings
    commission_amount - user_earnings
  end

  def user_earnings
    commission_amount * Search::Intent::USER_EARNINGS_SHARE
  end

  def user
    linkshare_merchant.intent.user
  end

  

  private

  def upadte_click_commission
    @clicks = Click.where(id: self.search_intent_id_received).last
    if !@clicks.blank?
      @clicks.update_attributes(commissionable_id: self.commission_id, commissionable_type: 'LinkshareCommission', cashback_amount: (commission_amount*0.3), eligiable_for_cashback: true)
    end
  end

  def close_search_intent_and_pay_commission
    return if !linkshare_merchant || !linkshare_merchant.intent
    search_intent = linkshare_merchant.intent
    search_intent.confirm_from_affiliate_merchant linkshare_merchant
  end
end
