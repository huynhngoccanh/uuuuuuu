class Admins::OutcomeReportsController < Admins::ApplicationController

  def index
    @outcome_reports = Search::IntentOutcome.includes(:intent).joins('inner join search_merchants on search_intent_outcomes.merchant_id = search_merchants.id').joins(:intent).joins('inner join users on users.id = search_intents.user_id').where('search_intents.status != "released"').order('search_intent_outcomes.updated_at desc').paginate(:page => params[:outcome_reports_page], :per_page => 10)
  end

  def release_money
    @report = Search::IntentOutcome.find(params[:intent_outcome_id])
    @intent = @report.intent
    if params['to_release']
      total = 0
      params['to_release'].each do |val|
        total += val.to_f
      end
      @intent.release_from_soleo(total)
      flash[:notice] = 'Successfully released ' + (ActionController::Base.helpers.number_to_currency total.to_s)
      redirect_to :action => :index and return
    end
    @selected_merchant = @report.selected_merchant
    @merchants = @intent.merchants
  end
end
