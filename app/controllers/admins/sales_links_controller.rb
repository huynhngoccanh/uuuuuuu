class Admins::SalesLinksController < Admins::ApplicationController

  def index
    @sales_owners = User.where(:sales_owner => true).order('first_name asc, last_name asc').paginate(:page => params[:sales_owner_page], :per_page => 10)
    @sales_group = SalesGroup.new

    # create group for sales owner
    if params[:sales_group]
      existing_count = SalesGroup.where(:name => params[:sales_group][:name]).count
      if existing_count > 0
        flash[:alert] = 'Group name should be unique.'
      else
        sales_group = SalesGroup.new(params[:sales_group])
        if sales_group.save
          flash[:notice] = 'Successfully created.'
        else
          flash[:alert] = sales_group.errors.full_messages
        end
      end
    end

    # update link name for sales name
    if params[:user]
      user = User.find(params[:user][:id])
      user.sales_name = params[:user][:sales_name]
      user.dont_require_password = true
      if user.save
        flash[:notice] = 'Successfully updated.'
      else
        flash[:alert] = user.errors.full_messages
      end
    end
  end

  def assign_user
    user = User.find_by_email(params[:email])
    sales_person = User.find_by_id(params[:user_id])
    if user && sales_person
      if user.referred_visit
        referred_visit = user.referred_visit
        referred_visit.user_id = sales_person.id
        referred_visit.sales_group = nil
        referred_visit.save
      else
        referred_visit = ReferredVisit.create(:user_id => sales_person.id)
        user.referred_visit = referred_visit
        user.save(:validate => false)
      end
      redirect_to admin_sales_links_path, :notice => 'User successfuly assigned to sales person.'
    else
      redirect_to admin_sales_links_path, :alert => 'There is no user with this email.'
    end
  end

  def show_group
    @group = SalesGroup.find(params[:group_id])
    @users = User.joins(:referred_visit).where('referred_visits.sales_group_id = ?', @group.id).order('users.created_at desc').paginate(:page => params[:users_page], :per_page => 10)
  end

  def revenue_report
    @sales_owner = User.find(params[:user_id])

    @intervals = []
    @date_end = Date.today
    @date_start = Date.today - 11.month
    @users_total = User.joins('INNER JOIN referred_visits ON referred_visits.id = users.referred_visit_id').where('referred_visits.user_id = ?', @sales_owner.id).where('DATE(referred_visits.created_at) BETWEEN ? AND ?', @date_start, @date_end).count

    date = @date_start
    while date < @date_end + 1.month
      data = {:period => date}
      data[:users_count] = User.joins('INNER JOIN referred_visits ON referred_visits.id = users.referred_visit_id').where('referred_visits.user_id = ?', @sales_owner.id).where('MONTH(referred_visits.created_at) = MONTH(?) and YEAR(referred_visits.created_at) = YEAR(?)', date, date).count
      data[:soleo] = Search::SoleoMerchant.select('sum(user_money) as user_money').joins(:intent).joins('inner join users on (users.id = search_intents.user_id)').joins('inner join referred_visits on (referred_visits.id = users.referred_visit_id)').where(:active => true).where('referred_visits.user_id = ?', @sales_owner.id).where('MONTH(search_merchants.updated_at) = MONTH(?) and YEAR(search_merchants.updated_at) = YEAR(?)', date, date).first.user_money || 0
      data[:soleo] = data[:soleo] / Search::Merchant::USER_MONEY_RATIO
      data[:cj] = Search::CjCommission.select('sum(commission_amount) as commission_amount').joins('inner join search_intents on (search_intents.id = search_cj_commissions.search_intent_id_received)').joins('inner join users on (users.id = search_intents.user_id)').joins('inner join referred_visits on (referred_visits.id = users.referred_visit_id)').where('referred_visits.user_id = ?', @sales_owner.id).where('MONTH(search_cj_commissions.occurred_at) = MONTH(?) and YEAR(search_cj_commissions.occurred_at) = YEAR(?)', date, date).first.commission_amount || 0
      data[:avant] = Search::AvantCommission.select('sum(commission_amount) as commission_amount').joins('inner join search_intents on (search_intents.id = search_avant_commissions.search_intent_id_received)').joins('inner join users on (users.id = search_intents.user_id)').joins('inner join referred_visits on (referred_visits.id = users.referred_visit_id)').where('referred_visits.user_id = ?', @sales_owner.id).where('MONTH(search_avant_commissions.occurred_at) = MONTH(?) and YEAR(search_avant_commissions.occurred_at) = YEAR(?)', date, date).first.commission_amount || 0
      data[:linkshare] = Search::LinkshareCommission.select('sum(commission_amount) as commission_amount').joins('inner join search_intents on (search_intents.id = search_linkshare_commissions.search_intent_id_received)').joins('inner join users on (users.id = search_intents.user_id)').joins('inner join referred_visits on (referred_visits.id = users.referred_visit_id)').where('referred_visits.user_id = ?', @sales_owner.id).where('MONTH(search_linkshare_commissions.occurred_at) = MONTH(?) and YEAR(search_linkshare_commissions.occurred_at) = YEAR(?)', date, date).first.commission_amount || 0
      data[:total] = data[:soleo] + data[:cj] + data[:avant] + data[:linkshare]
      @intervals.push(data)
      date = date.advance(:months => 1)
    end
    @revenue_total = @intervals.sum { |int| int[:total] }
    @intervals.reverse!
  end

  def revenue_daily_report
    @sales_owner = User.find(params[:user_id])

    @intervals = []
    @date_end = Date.today
    @date_end = Date.new(params[:year].to_i, params[:month].to_i, -1) if params[:month] && params[:year] && !(params[:month] == @date_end.month.to_s && params[:year] == @date_end.year.to_s)
    @date_start = @date_end.beginning_of_month
    @users_total = User.joins('INNER JOIN referred_visits ON referred_visits.id = users.referred_visit_id').where('referred_visits.user_id = ?', @sales_owner.id).where('DATE(referred_visits.created_at) BETWEEN ? AND ?', @date_start, @date_end).count

    date = @date_start
    while date < @date_end + 1.day
      data = {:period => date}
      data[:users_count] = User.joins('INNER JOIN referred_visits ON referred_visits.id = users.referred_visit_id').where('referred_visits.user_id = ?', @sales_owner.id).where('DATE(referred_visits.created_at) = ?', date).count
      data[:soleo] = Search::SoleoMerchant.select('sum(user_money) as user_money').joins(:intent).joins('inner join users on (users.id = search_intents.user_id)').joins('inner join referred_visits on (referred_visits.id = users.referred_visit_id)').where(:active => true).where('referred_visits.user_id = ?', @sales_owner.id).where('DATE(search_merchants.updated_at) = ?', date).first.user_money || 0
      data[:soleo] = data[:soleo] / Search::Merchant::USER_MONEY_RATIO
      data[:cj] = Search::CjCommission.select('sum(commission_amount) as commission_amount').joins('inner join search_intents on (search_intents.id = search_cj_commissions.search_intent_id_received)').joins('inner join users on (users.id = search_intents.user_id)').joins('inner join referred_visits on (referred_visits.id = users.referred_visit_id)').where('referred_visits.user_id = ?', @sales_owner.id).where('DATE(search_cj_commissions.occurred_at) = ?', date).first.commission_amount || 0
      data[:avant] = Search::AvantCommission.select('sum(commission_amount) as commission_amount').joins('inner join search_intents on (search_intents.id = search_avant_commissions.search_intent_id_received)').joins('inner join users on (users.id = search_intents.user_id)').joins('inner join referred_visits on (referred_visits.id = users.referred_visit_id)').where('referred_visits.user_id = ?', @sales_owner.id).where('DATE(search_avant_commissions.occurred_at) = ?', date).first.commission_amount || 0
      data[:linkshare] = Search::LinkshareCommission.select('sum(commission_amount) as commission_amount').joins('inner join search_intents on (search_intents.id = search_linkshare_commissions.search_intent_id_received)').joins('inner join users on (users.id = search_intents.user_id)').joins('inner join referred_visits on (referred_visits.id = users.referred_visit_id)').where('referred_visits.user_id = ?', @sales_owner.id).where('DATE(search_linkshare_commissions.occurred_at) = ?', date).first.commission_amount || 0
      data[:total] = data[:soleo] + data[:cj] + data[:avant] + data[:linkshare]
      @intervals.push(data)
      date = date.advance(:days => 1)
    end
    @revenue_total = @intervals.sum { |int| int[:total] }
    @intervals.reverse!

  end

  def revenue_day_report
    @sales_owner = User.find(params[:user_id])
    @intervals = []
    @date = Date.today
    @date = Date.new(params[:year].to_i, params[:month].to_i, params[:day].to_i) if params[:month] && params[:year] && params[:day]
    @users_total = User.joins('INNER JOIN referred_visits ON referred_visits.id = users.referred_visit_id').where('referred_visits.user_id = ?', @sales_owner.id).where('DATE(referred_visits.created_at) = ?', @date).count
    @reports = []
    soleo = Search::SoleoMerchant.select('search_merchants.*').joins(:intent).joins('inner join users on (users.id = search_intents.user_id)').joins('inner join referred_visits on (referred_visits.id = users.referred_visit_id)').where(:active => true).where('referred_visits.user_id = ?', @sales_owner.id).where('DATE(search_merchants.updated_at) = ?', @date).all
    soleo_src = soleo.collect { |sm| {:source => 'Soleo (pending)', :revenue => sm.user_money.to_f / Search::Merchant::USER_MONEY_RATIO , :company => sm.company_name, :time => sm.updated_at} }
    cj = Search::CjCommission.select('search_cj_comissions_merchants.commission_amount, search_cj_comissions_merchants.occurred_at').includes(:cj_merchant).joins('inner join search_intents on (search_intents.id = search_cj_commissions.search_intent_id_received)').joins('inner join users on (users.id = search_intents.user_id)').joins('inner join referred_visits on (referred_visits.id = users.referred_visit_id)').where('referred_visits.user_id = ?', @sales_owner.id).where('DATE(search_cj_commissions.occurred_at) = ?', @date).all
    cj_src = cj.collect { |sm| {:source => 'Cj', :revenue => sm.commission_amount, :company => sm.cj_merchant.company_name, :time => sm.occurred_at} }
    avant = Search::AvantCommission.select('search_avant_comissions_merchants.commission_amount, search_avant_comissions_merchants.occurred_at').includes(:avant_merchant).joins('inner join search_intents on (search_intents.id = search_avant_commissions.search_intent_id_received)').joins('inner join users on (users.id = search_intents.user_id)').joins('inner join referred_visits on (referred_visits.id = users.referred_visit_id)').where('referred_visits.user_id = ?', @sales_owner.id).where('DATE(search_avant_commissions.occurred_at) = ?', @date).all
    avant_src = avant.collect { |sm| {:source => 'Avant', :revenue => sm.commission_amount, :company => sm.avant_merchant.company_name, :time => sm.occurred_at} }
    linkshare = Search::LinkshareCommission.select('search_linkshare_comissions_merchants.commission_amount, search_linkshare_comissions_merchants.occurred_at').includes(:linkshare_merchant).joins('inner join search_intents on (search_intents.id = search_linkshare_commissions.search_intent_id_received)').joins('inner join users on (users.id = search_intents.user_id)').joins('inner join referred_visits on (referred_visits.id = users.referred_visit_id)').where('referred_visits.user_id = ?', @sales_owner.id).where('DATE(search_linkshare_commissions.occurred_at) = ?', @date).all
    linkshare_src = linkshare.collect { |sm| {:source => 'Linkshare', :revenue => sm.commission_amount, :company => sm.linkshare_merchant.company_name, :time => sm.occurred_at} }
    @reports = soleo_src + cj_src + avant_src + linkshare_src
    @revenue_total = @reports.sum { |int| int[:revenue] }
  end

end