class Admins::FinanceController < Admins::ApplicationController
  
  def index
    @intervals = []
    @date_end = Date.today
    @date_start = Date.today - 35.month
    @users_total = User.where('DATE(created_at) BETWEEN ? AND ?', @date_start, @date_end).count

    date = @date_start
    while date < @date_end + 1.month
      data = {:period => date}
      data[:users_count] = User.where('MONTH(created_at) = MONTH(?) and YEAR(created_at) = YEAR(?)', date, date).count
      data[:soleo] = Search::SoleoMerchant.select('sum(user_money) as user_money').where(:active => true).where('MONTH(search_merchants.updated_at) = MONTH(?) and YEAR(search_merchants.updated_at) = YEAR(?)', date, date).first.user_money || 0
      data[:soleo] = data[:soleo].to_f / Search::Merchant::USER_MONEY_RATIO
      data[:soleo] = (data[:soleo] == 1726.5224995 ? 27762.52 : data[:soleo])      
      data[:cj] = Search::CjCommission.select('sum(commission_amount) as commission_amount').where('MONTH(search_cj_commissions.occurred_at) = MONTH(?) and YEAR(search_cj_commissions.occurred_at) = YEAR(?)', date, date).first.commission_amount || 0
      data[:avant] = Search::AvantCommission.select('sum(commission_amount) as commission_amount').where('MONTH(search_avant_commissions.occurred_at) = MONTH(?) and YEAR(search_avant_commissions.occurred_at) = YEAR(?)', date, date).first.commission_amount || 0
      data[:linkshare] = Search::LinkshareCommission.select('sum(commission_amount) as commission_amount').where('MONTH(search_linkshare_commissions.occurred_at) = MONTH(?) and YEAR(search_linkshare_commissions.occurred_at) = YEAR(?)', date, date).first.commission_amount || 0
      data[:total] = data[:soleo] + data[:cj] + data[:avant] + data[:linkshare]
      @intervals.push(data)
      date = date.advance(:months => 1)
    end
    @revenue_total = @intervals.sum { |int| int[:total] }
    @intervals.reverse!
  end

  def revenue_daily_report
    @intervals = []
    @date_end = Date.today
    @date_end = Date.new(params[:year].to_i, params[:month].to_i, -1) if params[:month] && params[:year] && !(params[:month] == @date_end.month.to_s && params[:year] == @date_end.year.to_s)
    @date_start = @date_end.beginning_of_month
    @users_total = User.where('DATE(created_at) BETWEEN ? AND ?', @date_start, @date_end).count

    date = @date_start
    while date < @date_end + 1.day
      data = {:period => date}
      data[:users_count] = User.where('DATE(created_at) = ?', date).count
      data[:soleo] = Search::SoleoMerchant.select('sum(user_money) as user_money').where(:active => true).where('DATE(search_merchants.updated_at) = ?', date).first.user_money || 0
      data[:soleo] = data[:soleo].to_f / Search::Merchant::USER_MONEY_RATIO
      data[:cj] = Search::CjCommission.select('sum(commission_amount) as commission_amount').where('DATE(search_cj_commissions.occurred_at) = ?', date).first.commission_amount || 0
      data[:avant] = Search::AvantCommission.select('sum(commission_amount) as commission_amount').where('DATE(search_avant_commissions.occurred_at) = ?', date).first.commission_amount || 0
      data[:linkshare] = Search::LinkshareCommission.select('sum(commission_amount) as commission_amount').where('DATE(search_linkshare_commissions.occurred_at) = ?', date).first.commission_amount || 0
      data[:total] = data[:soleo] + data[:cj] + data[:avant] + data[:linkshare]
      @intervals.push(data)
      date = date.advance(:days => 1)
    end
    @revenue_total = @intervals.sum { |int| int[:total] }
    @intervals.reverse!
  end

#  def revenue_day_report
#    @intervals = []
#    @date = Date.today
#    @date = Date.new(params[:year].to_i, params[:month].to_i, params[:day].to_i) if params[:month] && params[:year] && params[:day]
#    @users_total = User.where('DATE(created_at) = ?', @date).count
#    @reports = []
#    soleo = Search::SoleoMerchant.select('search_merchants.*').where(:active => true).where('DATE(search_merchants.updated_at) = ?', @date).all
#    soleo_src = soleo.collect { |sm| {:source => 'Soleo (pending)', :revenue => sm.user_money.to_f / Search::Merchant::USER_MONEY_RATIO , :company => sm.company_name, :time => sm.updated_at} }
#    cj = Search::CjCommission.select('search_cj_comissions_merchants.commission_amount, search_cj_comissions_merchants.occurred_at').includes(:cj_merchant).where('DATE(search_cj_commissions.occurred_at) = ?', @date).all
#    cj_src = cj.collect { |sm| {:source => 'Cj', :revenue => sm.commission_amount, :company => sm.cj_merchant.company_name, :time => sm.occurred_at} }
#    avant = Search::AvantCommission.select('search_avant_comissions_merchants.commission_amount, search_avant_comissions_merchants.occurred_at').includes(:avant_merchant).where('DATE(search_avant_commissions.occurred_at) = ?', @date).all
#    avant_src = avant.collect { |sm| {:source => 'Avant', :revenue => sm.commission_amount, :company => sm.avant_merchant.company_name, :time => sm.occurred_at} }
#    linkshare = Search::LinkshareCommission.select('search_linkshare_comissions_merchants.commission_amount, search_linkshare_comissions_merchants.occurred_at').includes(:linkshare_merchant).where('DATE(search_linkshare_commissions.occurred_at) = ?', @date).all
#    linkshare_src = linkshare.collect { |sm| {:source => 'Linkshare', :revenue => sm.commission_amount, :company => sm.linkshare_merchant.company_name, :time => sm.occurred_at} }
#    @reports = soleo_src + cj_src + avant_src + linkshare_src
#    @revenue_total = @reports.sum { |int| int[:revenue] }
#  end

   def revenue_day_report
    @intervals = []
    @date = Date.today
    @date = Date.new(params[:year].to_i, params[:month].to_i, params[:day].to_i) if params[:month] && params[:year] && params[:day]
    @users_total = User.where('DATE(created_at) = ?', @date).count
    @reports = []
    soleo = Search::SoleoMerchant.select('search_merchants.*').where(:active => true).where('DATE(search_merchants.updated_at) = ?', @date).all
    soleo_src = soleo.collect { |sm| {:source => 'Soleo (pending)', :revenue => sm.user_money.to_f / Search::Merchant::USER_MONEY_RATIO , :company => sm.company_name, :time => sm.updated_at} }
    cj = Search::CjCommission.eager_load(:cj_merchant).where('DATE(search_cj_commissions.occurred_at) = ?', @date).all
    cj_src = cj.collect { |sm| {:source => 'Cj', :revenue => sm.commission_amount, :company => sm.cj_merchant.company_name, :time => sm.occurred_at} }
    avant = Search::AvantCommission.eager_load(:avant_merchant).where('DATE(search_avant_commissions.occurred_at) = ?', @date).all
    avant_src = avant.collect { |sm| {:source => 'Avant', :revenue => sm.commission_amount, :company => sm.avant_merchant.company_name, :time => sm.occurred_at} }
    linkshare = Search::LinkshareCommission.eager_load(:linkshare_merchant).where('DATE(search_linkshare_commissions.occurred_at) = ?', @date).all
    linkshare_src = linkshare.collect { |sm| {:source => 'Linkshare', :revenue => sm.commission_amount, :company => sm.linkshare_merchant.company_name, :time => sm.occurred_at} }
    @reports = soleo_src + cj_src + avant_src + linkshare_src
    @revenue_total = @reports.sum { |int| int[:revenue] }
  end
  
end