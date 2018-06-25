class Search::Intent < ActiveRecord::Base
  USER_EARNINGS_SHARE = 0.7

  STATUSES = ['active', 'confirmed', 'released']

  has_many :merchants, :dependent => :delete_all
  has_one :intent_outcome, :dependent => :delete
  belongs_to :user

  def commission
    com = Search::CjCommission.where('search_intent_id_received = ?', id).first
    com = Search::AvantCommission.where('search_intent_id_received = ?', id).first if com.nil?
    com = Search::LinkshareCommission.where('search_intent_id_received = ?', id).first if com.nil?
    com = Search::PjCommission.where('search_intent_id_received = ?', id).first if com.nil?
    com = Search::IrCommission.where('search_intent_id_received = ?', id).first if com.nil?
    com
  end

  def confirm_from_affiliate_merchant(search_merchant)
    return if search_merchant.commission.nil?

    update_attribute :status, 'confirmed'
    update_attribute :user_earnings, (user_earnings || 0) + search_merchant.commission.user_earnings

    if user.referred_visit && user.referred_visit.sales_group && user.created_at + 3.month > Time.now
      MuddlemeTransaction.create_for(search_merchant.commission, true)
    else
      MuddlemeTransaction.create_for search_merchant.commission
      UserTransaction.create_for search_merchant.commission
      user.post_search_ended_to_facebook search_merchant.commission.user_earnings
      user.post_search_ended_to_twitter search_merchant.commission.user_earnings
    end

    begin
      SearchMailer.search_ended_from_affiliate(search_merchant.intent, search_merchant).deliver if user.initiated_auction_mail?
    rescue StandardError => e
      logger.error e.message
    end

    if user.referred_visit && !user.sales_owner
      user.referred_visit.add_referred_earnings search_merchant.commission.commission_amount
      UserTransaction.create_for user.referred_visit
      MuddlemeTransaction.create_for user.referred_visit
    end
  end

  def release_from_soleo(released_earnings)
    update_attribute :status, 'released'
    update_attribute :user_earnings, released_earnings

    unless user.referred_visit && user.referred_visit.sales_group && user.created_at + 3.month > Time.now
      UserTransaction.create_for self
    end

    if user.referred_visit && !user.sales_owner
      user.referred_visit.add_referred_earnings released_earnings
      UserTransaction.create_for user.referred_visit
    end
  end

  def ended?
    days_left = 7 - (Time.now.to_date - created_at.to_date)
    days_left < 1 || status == STATUSES[1]
  end

  def end_time
    if status == STATUSES[0]
      created_at + 7.days
    else
      updated_at
    end
  end

  def revenue
    soleo = merchants.select('SUM(user_money) as user_money').where(:type => Search::SoleoMerchant.name).where(:active => true).first.user_money || 0
    cj = self.class.select('SUM(commission_amount) as commission_amount').joins('inner join search_cj_commissions on search_cj_commissions.search_intent_id_received = search_intents.id').where('search_intents.id = ?', id).first.commission_amount || 0
    avant = self.class.select('SUM(commission_amount) as commission_amount').joins('inner join search_avant_commissions on search_avant_commissions.search_intent_id_received = search_intents.id').where('search_intents.id = ?', id).first.commission_amount || 0
    linkshare = self.class.select('SUM(commission_amount) as commission_amount').joins('inner join search_linkshare_commissions on search_linkshare_commissions.search_intent_id_received = search_intents.id').where('search_intents.id = ?', id).first.commission_amount || 0
    pj = self.class.select('SUM(commission_amount) as commission_amount').joins('inner join search_pj_commissions on search_pj_commissions.search_intent_id_received = search_intents.id').where('search_intents.id = ?', id).first.commission_amount || 0
    ir = self.class.select('SUM(commission_amount) as commission_amount').joins('inner join search_ir_commissions on search_ir_commissions.search_intent_id_received = search_intents.id').where('search_intents.id = ?', id).first.commission_amount || 0
    soleo + cj + avant + linkshare + pj + ir
  end

  def self.check_requested_query(query)
    special = "?<>',?[]}{=-)(*+&^%$#`~{}:/"
    regex = /[#{special.gsub(/./){|char| "\\#{char}"}}]/
    query.gsub(regex){|match|"\\"  + match}
  end

  def unconfirmed?
    intent_outcome.nil? && status != 'confirmed'
  end

  def send_soleo_callback
    Delayed::Worker.logger.info '********************************************* ' + Time.now.in_time_zone('Eastern Time (Asia/Kolkata)').strftime('%m-%d-%y %I-%M-%S %p') + ' *********************************************'
    Delayed::Worker.logger.info "******* Performing callback for intent: #{id}:#{search}"
    # Callback request for soleo
    soleo_merchants = merchants.where(:type => Search::SoleoMerchant.name)
    Delayed::Worker.logger.info '******* All soleo merchants: ' + soleo_merchants.length.to_s
    if soleo_merchants.length > 0
      attempted_call_merchant = merchants.where(:type => Search::SoleoMerchant.name).where(:active => true).order('updated_at desc').first
      active_merchants = 0
      # ======================= Soleo prepare XML =======================
      builder = Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
        xml.request('client-tracking-id' => id, :xmlns => 'http://soleosearch.flexiq.soleo.com') {
          xml.callback('request-type' => 'pay-per-call') {
            soleo_merchants.each do |merchant|
              # if was not sent earlier and not expired
              if merchant.params['callback_sent'].nil? && merchant.params['expired_at'] > Time.now
                Delayed::Worker.logger.info '******* Merchant accepted: [id]' + merchant.id.to_s + '[company]' + merchant.company_name + '[phone]' + merchant.company_phone + '[callback_sent]' + merchant.params['callback_sent'].to_s + '[expired_at]' + merchant.params['expired_at'].in_time_zone('Eastern Time (Asia/Kolkata)').strftime('%m-%d-%y %I-%M-%S %p') + '[now]' + Time.now.in_time_zone('Eastern Time (Asia/Kolkata)').strftime('%m-%d-%y %I-%M-%S %p')
                xml.listing('id' => merchant.params['listing_id'], 'tracking-url' => merchant.params['tracking_url']) {
                  xml.selected('merchant-number' => merchant.company_phone)
                  xml.send('presented-name', 'position' => merchant.params['position'], 'used-name-audio' => false)
                  xml.send('presented-number', 'position' => merchant.params['position'])
                  xml.send('attempted-call-completion') if (attempted_call_merchant.present? && merchant.id == attempted_call_merchant.id)
                }
                active_merchants += 1 if merchant.active
                merchant.params['callback_sent'] = 1
                merchant.save
              else
                Delayed::Worker.logger.info '******* Merchant NOT accepted: [id]' + merchant.id.to_s + '[company]' + merchant.company_name + '[phone]' + merchant.company_phone + '[callback_sent]' + merchant.params['callback_sent'].to_s + '[expired_at]' + merchant.params['expired_at'].in_time_zone('Eastern Time (Asia/Kolkata)').strftime('%m-%d-%y %I-%M-%S %p') + '[now]' + Time.now.in_time_zone('Eastern Time (Asia/Kolkata)').strftime('%m-%d-%y %I-%M-%S %p')
              end
            end
          }
        }
      end
      callback_request = Typhoeus::Request.new('https://mobapi.soleocom.com/xapi/query', :method => :post, :userpwd => $soleo_basic_auth, :body => builder.to_xml)
      Delayed::Worker.logger.info '******* ' + Time.now.in_time_zone('Eastern Time (Asia/Kolkata)').strftime('%m-%d-%y %I-%M-%S %p') + ': Soleo callback request:'
      Delayed::Worker.logger.info '******* '+ builder.to_xml.to_s

      response = callback_request.run
      Delayed::Worker.logger.info '******* ' + Time.now.in_time_zone('Eastern Time (Asia/Kolkata)').strftime('%m-%d-%y %I-%M-%S %p') + ': Soleo callback response:'
      Delayed::Worker.logger.info '******* ' + response.body
      Delayed::Worker.logger.info '******* Sending email to user '
      begin
        SearchMailer.search_ended_from_soleo(self).deliver if active_merchants > 0
      rescue StandardError => e
        Delayed::Worker.logger.info e.message
      end
    else
      Delayed::Worker.logger.info '******* ' + Time.now.in_time_zone('Eastern Time (Asia/Kolkata)').strftime('%m-%d-%y %I-%M-%S %p') + ': No merchants for soleo callback'
    end

  end
end
