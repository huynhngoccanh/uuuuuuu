class Search::IrCommission < ActiveRecord::Base
  belongs_to :ir_merchant
  has_one :muddleme_transaction, :as=>:transactable, :dependent=>:destroy
  has_one :user_transaction, :as=>:transactable, :dependent=>:destroy
  serialize :params

  after_create :close_search_intent_and_pay_commission
  after_create :upadte_click_commission

  before_update {raise ActiveRecord::ReadOnlyRecord}
  before_destroy {raise ActiveRecord::ReadOnlyRecord}

  def set_attributes_from_response_row(row)
    self.params                                      = row
    self.commission_id                        = row['Id']
    self.commission_amount             = row['Payout']
    self.price                                           = row['Amount']
    self.search_intent_id_received  = row['SubId1']
    self.occurred_at                             = row['EventDate']

    self.resulting_balance    = SystemStats.system_balance + self.commission_amount

    search_intent = Search::Intent.find_by_id search_intent_id_received
    return nil unless search_intent

    ir_advertiser = IrAdvertiser.find_by_advertiser_id(row['CampaignId'])
    return nil unless ir_advertiser

    ir_merchant_found = search_intent.merchants.where(:db_id => ir_advertiser.id).first
    return nil unless ir_merchant_found

    self.ir_merchant = ir_merchant_found
    self
  end

  def self.fetch_new_commissions
    page = 0
    begin
      page += 1
      commissions = IR.commission_details page
      unless commissions.blank?
        commissions.each do |row|
          if row['State'] == "APPROVED"
            next if self.find_by_commission_id row['Id']
            new_comission = self.new.set_attributes_from_response_row(row)
            new_comission.save! unless new_comission.nil?
          end
        end
      end
    end
  end

  def muddleme_earnings
    commission_amount - user_earnings
  end

  def user_earnings
    commission_amount * Search::Intent::USER_EARNINGS_SHARE
  end

  def user
    ir_merchant.intent.user
  end


  private

  def upadte_click_commission
    @clicks = Click.where(id: self.search_intent_id_received).last
    if !@clicks.blank?
      @clicks.update_attributes(commissionable_id: self.commission_id, commissionable_type: 'IrCommission', cashback_amount: (commission_amount*0.3), eligiable_for_cashback: true)
    end
  end

  def close_search_intent_and_pay_commission
    return if !ir_merchant || !ir_merchant.intent
    search_intent = ir_merchant.intent
    search_intent.confirm_from_affiliate_merchant ir_merchant
  end
end
