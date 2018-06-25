class Search::PjCommission < ActiveRecord::Base
  belongs_to :pj_merchant
  has_one :muddleme_transaction, :as=>:transactable, :dependent=>:destroy
  has_one :user_transaction, :as=>:transactable, :dependent=>:destroy
  serialize :params

  after_create :close_search_intent_and_pay_commission
  after_create :upadte_click_commission

  before_update {raise ActiveRecord::ReadOnlyRecord}
  before_destroy {raise ActiveRecord::ReadOnlyRecord}

  def set_attributes_from_response_row(row)
    self.params               = row
    self.commission_id        = row['transaction_id']
    self.commission_amount    = row['commission']
    self.price                = row['sale_amount']
    self.search_intent_id_received = row['sid']
    self.occurred_at          = row['date']

    self.resulting_balance    = SystemStats.system_balance + self.commission_amount

    search_intent = Search::Intent.find_by_id search_intent_id_received
    return nil unless search_intent

    pj_advertiser = PjAdvertiser.find_by_advertiser_id(row['program_id'])
    return nil unless pj_advertiser

    pj_merchant_found = search_intent.merchants.where(:db_id => pj_advertiser.id).first
    return nil unless pj_merchant_found

    self.pj_merchant = pj_merchant_found
    self
  end

  def self.fetch_new_commissions
    response = PJ.commission_details

    return unless response['data']
    commissions = response['data']
    commissions = [commissions] if !commissions.is_a? Array
    commissions.each do |row|
      next if self.find_by_commission_id row['commission_id']
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
    pj_merchant.intent.user
  end

  

  private

  def upadte_click_commission
    @clicks = Click.where(id: self.search_intent_id_received).last
    if !@clicks.blank?
      @clicks.update_attributes(commissionable_id: self.commission_id, commissionable_type: 'PjCommission', cashback_amount: (commission_amount*0.3), eligiable_for_cashback: true)
    end
  end

  def close_search_intent_and_pay_commission
    return if !pj_merchant || !pj_merchant.intent
    search_intent = pj_merchant.intent
    search_intent.confirm_from_affiliate_merchant pj_merchant
  end
  
end
