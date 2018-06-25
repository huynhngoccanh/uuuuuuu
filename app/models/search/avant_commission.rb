class Search::AvantCommission < ActiveRecord::Base
  belongs_to :avant_merchant
  has_one :muddleme_transaction, :as=>:transactable, :dependent=>:destroy
  has_one :user_transaction, :as=>:transactable, :dependent=>:destroy
  serialize :params

  after_create :close_search_intent_and_pay_commission
  # after_create :update_click

  after_create :upadte_click_commission

  before_update {raise ActiveRecord::ReadOnlyRecord}
  before_destroy {raise ActiveRecord::ReadOnlyRecord}

  def set_attributes_from_response_row(row)
    self.price                = row['Transaction_Amount'].gsub('$','').to_f
    self.commission_amount    = row['Total_Commission'].gsub('$','').to_f
    self.search_intent_id_received  = row['Custom_Tracking_Code']
    self.occurred_at          = row['Transaction_Date']
    self.commission_id        = row['AvantLink_Transaction_Id']
    self.params               = row
    self.resulting_balance    = SystemStats.system_balance + self.commission_amount

    search_intent = Search::Intent.find_by_id search_intent_id_received
    return nil unless search_intent

    avant_advertiser = AvantAdvertiser.find_by_advertiser_id(row['Merchant_Id'])
    return nil unless avant_advertiser

    avant_merchant_found = search_intent.merchants.where(:db_id => avant_advertiser.id).first
    return nil unless avant_merchant_found

    self.avant_merchant = avant_merchant_found
    self
  end

  def self.fetch_new_commissions
    response = Avant.commission_details

    response.to_a.each do |row|
      next if self.find_by_commission_id row['AvantLink_Transaction_Id']
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
    avant_merchant.intent.user
  end


  private

    def upadte_click_commission
      @clicks = Click.where(id: self.search_intent_id_received).last
      if !@clicks.blank?
        @clicks.update_attributes(commissionable_id: self.commission_id, commissionable_type: 'AvantCommission', cashback_amount: (commission_amount*0.3), eligiable_for_cashback: true)
      end
    end

    # def update_click
    #   Click.where(id: search_intent_id_received).last.update_attributes(cashback_amount: (commission_amount*0.3), eligiable_for_cashback: true)
    # end

    def close_search_intent_and_pay_commission
      return if !avant_merchant || !avant_merchant.intent
      search_intent = avant_merchant.intent
      search_intent.confirm_from_affiliate_merchant avant_merchant
    end
end
