class Vendors::Devise::SessionsController < Devise::SessionsController
  #sing out user when loggin in vendor
  before_filter :only => "create" do
    sign_out :user
    sign_out :admin
  end
  #go to user login page if user logged in
  before_filter :only => "new" do
    redirect_to :controller=>'users/devise/sessions', :action=>'new' unless current_user.nil?
    redirect_to :controller=>'admins/devise/sessions', :action=>'new' unless current_admin.nil?
  end

  after_filter :only => "create" do
    new_leads = Search::Intent.joins(:intent_outcome).where('search_intent_outcomes.purchase_made = 1 and search_intent_outcomes.merchant_id = ?', current_vendor.id).joins(:merchants).where('search_merchants.active = true').where('search_merchants.db_id = ?', current_vendor.id).order('search_intents.created_at desc').where('search_intents.created_at > ?', current_vendor.last_sign_in_at).count
    session[:new_leads] = new_leads if (new_leads > 0)
  end
end
