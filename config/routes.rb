# require File.expand_path("../../lib/routes_constraints", __FILE__)
require 'sidekiq/web'
MuddleMe::Application.routes.draw do

  apipie
  mount Sidekiq::Web => '/sidekiq'
  mount Facebook::Messenger::Server, at: 'bot'

  get "validate_session" => "welcome#validate_session"
  get "retail" => "welcome#retail"
  get "services" => "welcome#services"
  get "learn_more" => "welcome#learn_more"
  get "travel" => "welcome#travel"
  get "loyalty" => "welcome#loyalty"
  get 'referral' => 'welcome#referral'
  get "loyalty_result" => "welcome#loyalty_result"
  post "qualified_pro"  => "welcome#qualified_pro"

  post "/webhook" =>  "welcome#webhook"

  resources :products
  resources :coupons


  namespace :admins do
    resources :merchants do
      collection do
        get :download_csv_file_most_seached_merchants
        get :loyalty_programs_users
        get :download_csv_file_loyalty_programs
        get :download_csv_commission_deatils
      end
    end
    resources :query
    resources :avant_advertiser
    resources :cj_advertiser
    resources :pj_advertiser
    resources :ir_advertiser
    resources :linkshare_advertiser
    resources :coupons do
      collection do
        get :download_csv_file_coupon
      end
    end
    resources :service_request do
      collection do
        get :download_csv_file
        get :click
      end
    end

  end

  namespace :api do
    namespace :v1 do

      resources :store do
        collection do
        get :near_by
          end
        end
      resources :payment_histories do
        collection do
          post :create_pay_request
        end
      end

      resources :users do
        collection do
          get :my_loyalty_programs
          get :loyalty_programs
          get :my_loyalty_program_details
        end
      end
      resources :registrations,:only => [:create]
      resources :sessions, :only => [:create, :destroy]
      resources :passwords
      resources :profile do
        collection do
          get :user_earning
        end
      end
      resources :loyalty_programs
      resources :loyalty_programs_users
      resources :likes
      resources :user_favourites
      resources :merchants do
        collection do
          get :mobile_created
          get :coupons
          get :merchant_find
        end
      end
      resources :coupons do
        collection do
          get :coupons
          get :send_coupon_by_email
          get :send_coupon_by_sms
        end
      end
      resources :taxons do
        collection do
          get :search
          post :get_number
        end
      end
      resources :autocompletes do
        collection do
          get :search
          get :services
        end
      end
      namespace :admin do
        resources :taxons
        resources :placements
        resources :merchants do
          collection do
            get :avant_advertiser
            get :cj_advertiser
            get :pj_advertiser
            get :ir_advertiser
            get :linkshare_advertiser
          end
        end
        resources :taxonomies do
          member do
            get :taxons
          end
        end
      end
    end
  end

  get "/merchants/:slug" => "merchants#index", as: :merchants
  get "/merchants/:slug/coupons" => "merchants#coupons"
  get "/merchants/:slug/:coupon_type/coupons" => "merchants#coupons"
  get "/merchants/:id/redirect" => "merchants#redirect", as: :merchants_redirect
  get "/profile/activity" => "welcome#activity", as: :user_activity
  get "/coupons" => "coupons#index"
  get "/products/*id" => "products#index"
  resources :coupons, only: [:index] do
    member do
      get :redirect
    end
  end

#  namespace :admins do
#  get 'purchase_history/index'
#  end
#
#  namespace :admins do
#  get 'purchase_history/show'
#  end
  resources :invite_users
  resources :loyalty_programs_users
  resources :loyalty_program_coupons
  use_doorkeeper
  resources :loyalty_program_offer_images
  resources :loyalty_program_offers


  use_doorkeeper
  namespace :admins do resources :store_categories end
  namespace :admins do resources :product_categories end
  namespace :admins do resources :review_submitted_coupons end

  # ======== mm box web app routes =============
  get "/taxons/*nested_name", to: "coupons#show", as: :coupons_show
  get '/search/autocomplete_muddleme_search' => "search#autocomplete_muddleme_search"
  get '/search/autocomplete_service_search' => "search#autocomplete_service_search"
  get '/google_search' => 'search#google_search', :as => :google_search
  get '/mm_box_search' => 'search#search'
  get '/mm_prompt_cc_window' => 'search#prompt_cc_window'
  post '/hp_mm_box_merchants_search' => 'search#hp_merchants_search'
  get '/search/:search_by_merchants' => 'search#merchants_search'
  # get '/search' => 'search#merchants_search'
  get '/favorite' => 'search#add_favorite_merchant'
  post '/favorite' => 'search#add_favorite_merchant'
  get '/remove_favorite' => 'search#remove_favorite_merchant'
  post '/remove_favorite' => 'search#remove_favorite_merchant'
  get '/hp_pc_merchants' => 'search#hp_pc_merchants'
  post '/hp_mm_box_services_search' => 'search#hp_services_search'
  get '/mm_zip_code_window' => 'search#prompt_zipcode_window'
  get '/mm_box_search_lite' => 'search#search_lite'
  get '/mm_affiliate_merchants_search' => 'search#affiliate_search'
  get '/mm_box_get_current_user' => 'search#get_current_user'
  post '/mm_activate_merchant' => 'search#activate_merchant'
  get '/mm_extension_background_iframe' => 'search#extension_background_iframe'
  get '/mm_box_get_user_messages' => 'search#get_user_messages'
  post '/mm_box_remove_user_message' => 'search#remove_user_message'
  post '/mm_skip_info_before_shopping' => 'search#skip_info_before_shopping'
  get '/mm_check_coupons_by_location' => 'search#check_coupons_by_location'
  get '/muddleme-search' =>'search#muddleme_search'
  put '/users/single_sign_in' => 'users#single_sign_in'

  # ========= bing search ===================
  get '/bing_search' => 'search#bing_search'

  # utils
  get '/rtest' => 'search#rtest'
  post '/rtest' => 'search#rtest'
  post '/rupload' => 'search#rupload'

  # tmp
  get '/linkshare_mapping' => 'search#linkshare_mapping'
  get '/cj_mapping' => 'search#cj_mapping'
  get '/avant_mapping' => 'search#avant_mapping'
  get '/pj_mapping' => 'search#pj_mapping'
  get '/mm_soleo_number_clicks_report' => 'search#mm_soleo_number_clicks_report'

  # extensions
  get '/mm-extension' => 'application#mm_extension'
  get '/mm-extension-lite' => 'application#mm_extension_lite'
  get '/mm-ie-extension' => 'application#mm_ie_extension'
  get '/mm-firefox-extension' => 'application#mm_firefox_extension'
  get '/mm-chrome-extension' => 'application#mm_chrome_extension'

  get '/safari-extension.safariextz' => 'application#mm_safari_extension'
  get '/safari-extension-lite.safariextz' => 'application#mm_safari_extension_lite'
  get '/safari-extension.plist' => 'application#mm_safari_extension_plist'

  get '/enable-ie' => 'application#enable_ie'
  get '/enable-safari' => 'application#enable_safari'


  # ======== mm box web app routes =============
  # ======== backend routes =============
  get '/search_requests' => 'users/search_requests#index'
  get '/search_requests/:id' => 'users/search_requests#show'
  get '/search_requests/:id/outcome' => 'users/search_requests#outcome'
  post '/search_requests/:id/update_outcome' => 'users/search_requests#update_outcome'
  # ======== backend routes =============


  match '/api/auth/facebook/callback' => 'users/api_omniauth_callbacks#facebook', via: [:get, :post]
  match '/api/auth/twitter/callback' => 'users/api_omniauth_callbacks#twitter', via: [:get, :post]
  match '/api/auth/google_oauth2/callback' => 'users/api_omniauth_callbacks#google_oauth2', via: [:get, :post]

  post '/api/omniauth_login' => 'users/api_omniauth_callbacks#omniauth_login', format: :json
  # mount Api => "/api"



  # get '/', :to => "users#dashboard"
  # get '/', :to => "vendors#dashboard"
  get 'admins/home', :to => "admins/finance#index"

  get 'admins/loyalty_program_stores', :to => "admins/loyalty_program_stores#index"
  post 'admins/loyalty_program_stores', :to => "admins/loyalty_program_stores#import"

  get '/loyalty_program', :to => "vendors/loyalty_programs#edit"
  post '/loyalty_program', :to => "vendors/loyalty_programs#update"

  get 'admins/review_submitted_coupons', :to => "admins/review_submitted_coupons#index"

  root :to => 'welcome#index'
  get '/experience' => 'application#experience'
  # get '/referral' => 'application#referral'
  post '/hp_user_sign_up' => 'users#hp_user_sign_up'
  post '/check_subscriber_email' => 'users#check_subscriber_email'
  get '/hp_direct_sign_up' => 'users#hp_direct_sign_up'
  post '/send_sms' => 'users#send_sms_to_users'
  get '/load_more_posts' => 'users#load_more_posts'

  devise_for :users, :controllers => {
    :sessions => "users/devise/sessions",
    :passwords => "users/devise/passwords",
    :registrations => "users/devise/registrations",
    :confirmations => "users/devise/confirmations",
    :unlocks => "users/devise/unlocks",
    :omniauth_callbacks => "users/devise/omniauth_callbacks"
  },
  :skip=>[:sessions, :passwords, :confirmations, :registrations]

  devise_scope :user do
    get     '/login'   => 'users/devise/sessions#new', :as => "new_user_session"
    post    '/login'   => 'users/devise/sessions#create', :as => "user_session"
    delete  '/logout'  => 'users/devise/sessions#destroy', :as => "destroy_user_session"
    post    '/reset/send'   => 'users/devise/passwords#create', :as => "user_password"
    get     '/reset/send'   => 'users/devise/passwords#new', :as => "new_user_password"
    get     '/reset'        => 'users/devise/passwords#edit', :as => "edit_user_password"
    put     '/reset'        => 'users/devise/passwords#update', :as => "update_user_password"
    get     '/signup'  => 'users/devise/registrations#new', :as => "new_user_registration"
    post    '/signup'  => 'users/devise/registrations#new'
    get     '/signup/:token'  => 'users/devise/registrations#new' ,:as => "new_referred_user_registration"

    post    '/signup/create'  => 'users/devise/registrations#create', :as => 'user_registration'
    get     '/confirm' => 'users/devise/confirmations#show', :as => "user_confirmation"
    get     '/confirm_new' => 'users/devise/confirmations#new', :as => "new_user_confirmation"
    post    '/confirm' => 'users/devise/confirmations#create'
  end

  devise_for :vendors,
    :controllers => {
    :sessions => "vendors/devise/sessions",
    :passwords => "vendors/devise/passwords",
    :registrations => "vendors/devise/registrations",
    :confirmations => "vendors/devise/confirmations",
    :unlocks => "vendors/devise/unlocks",
  },
    :skip=>[:sessions, :passwords, :confirmations, :registrations]

  devise_scope :vendor  do
    get     '/company/login'   => 'vendors/devise/sessions#new', :as => "new_vendor_session"
    post    '/company/login'   => 'vendors/devise/sessions#create', :as => "vendor_session"
    delete  '/company/logout'  => 'vendors/devise/sessions#destroy', :as => "destroy_vendor_session"
    post    '/company/reset/send'   => 'vendors/devise/passwords#create', :as => "vendor_password"
    get     '/company/reset/send'   => 'vendors/devise/passwords#new', :as => "new_vendor_password"
    get     '/company/reset'        => 'vendors/devise/passwords#edit', :as => "edit_vendor_password"
    put     '/company/reset'        => 'vendors/devise/passwords#update', :as => "update_vendor_password"
    get     '/company/signup_original'  => 'vendors/devise/registrations#original'
    get     '/company/signup_premium'  => 'vendors/devise/registrations#premium'
    get     '/company/signup'  => 'vendors/devise/registrations#new', :as => "new_vendor_registration"
    post    '/company/signup'  => 'vendors/devise/registrations#new'
    get     '/company/signup/step1'  => 'vendors/devise/registrations#step1', :as => "step1_vendor_registration"
    post    '/company/signup/step1'  => 'vendors/devise/registrations#step1'
    get     '/company/signup/step2' => 'vendors/devise/registrations#step2', :as => "step2_vendor_registration"
    post    '/company/signup/step2' => 'vendors/devise/registrations#step2'
    post    '/company/signup/create'  => 'vendors/devise/registrations#create', :as => 'vendor_registration'
    get     '/company/confirm' => 'vendors/devise/confirmations#show', :as => "vendor_confirmation"
    get     '/company/confirm_new' => 'vendors/devise/confirmations#new', :as => "new_vendor_confirmation"
    post    '/company/confirm' => 'vendors/devise/confirmations#create'
  end

  devise_for :admins,
    :controllers => {
    :sessions => "admins/devise/sessions",
    :passwords => "admins/devise/passwords",
  },
    :skip=>[:sessions, :passwords]

  devise_scope :admin do
    get     '/admin'   => 'admins/devise/sessions#new', :as => "new_admin_session"
    post    '/admin'   => 'admins/devise/sessions#create', :as => "admin_session"
    delete  '/admin/logout'  => 'admins/devise/sessions#destroy', :as => "destroy_admin_session"
    post    '/admin/reset/send'   => 'admins/devise/passwords#create', :as => "admin_password"
    get     '/admin/reset/send'   => 'admins/devise/passwords#new', :as => "new_admin_password"
    get     '/admin/reset'        => 'admins/devise/passwords#edit', :as => "edit_admin_password"
    put     '/admin/reset'        => 'admins/devise/passwords#update', :as => "update_admin_password"
  end

  get '/contact' => 'contact_messages#new', :as => 'contact'
  post '/contact' => 'contact_messages#create'

  match '/what_is_muddle_me', :to=>'users#what_is_muddle_me', via: :get
  match '/what_is_it', :to=>'users#what_is_muddle_me', via: :get
  match '/about', :to=>'users#what_is_muddle_me', via: :get
  match '/how_it_works', :to=>'users#how_it_works', via: :get
  match '/terms_and_conditions', :to => 'users#terms_and_conditions', via: :get
  match '/privacy_policy', :to => 'users#privacy_policy', via: :get
  match '/faq', :to => 'users#faq', via: :get
  match '/UC', :to => 'users#university', via: :get
  match '/uc', :to => 'users#university', via: :get
  match '/IAC', :to => 'users#iac', via: :get
  match '/iac', :to => 'users#iac', via: :get


  match "/company", :to => "vendors#dashboard", :as=>'company', via: [:get, :post]
  match "/company", :to => "vendors#index", via: [:get, :post]

  match '/company/what_is_muddle_me', :to=>'vendors#what_is_muddle_me', via: :get
  match '/company/what_is_it', :to=>'vendors#what_is_muddle_me', via: :get
  match '/company/about', :to=>'vendors#what_is_muddle_me', via: :get
  match '/company/how_it_works', :to=>'vendors#how_it_works', via: :get
  match '/company/terms_and_conditions', :to => 'vendors#terms_and_conditions', via: :get
  match '/company/privacy_policy', :to => 'vendors#privacy_policy', via: :get

  match '/details/categories', :to => "vendors#categories", :via => :get
  match '/details', :to => "vendors#update", :via => :put


  match '/paypal_ipns', :to=>'paypal_notifications#notify', via: [:get, :post]

  #unused anymore
  #match "/dashboard", :to => "users#dashboard", :as => "user_dashboard", :via => :get
  #match "/dashboard", :to => "vendors#dashboard", :as => "vendor_dashboard", :via => :get

  resources :auctions, :controller=>'users/auctions',
    :except=>[:edit, :destroy] do
    get 'in_progress', :on=>:collection
    get 'finished', :on=>:collection
    get 'unconfirmed', :on=>:collection
    get 'product', :on=>:new
    get 'service', :on=>:new
    post 'validate', :on=>:new
    get 'confirm', :on=>:new
    post 'cancel', :on=>:new
    get 'resolve', :on=>:member
    get 'create_success', :on=>:member
    post 'upload_image', :on=>:new
    get 'uploaded_images', :on=>:new
    get 'outcome', :on=>:member
    put 'update_outcome', :on=>:member
    get 'check_offers', :on=>:member
  end

  match 'auctions/:id/print_offer/:offer_id', :to=>"users/auctions#print_offer", :as=>'auction_print_offer', via: [:get, :post]
  match 'showcoupons/:type/:id', :to=>"users/auctions#coupons", :as=>'auction_coupons', via: [:get, :post]

  resources :favorite_advertisers, :controller=>'users/favorite_advertisers', :except=>[:edit, :update] do
    post 'replace', :on => :collection
  end

  resources :user_service_providers, :controller=>'users/user_service_providers' do
    #post 'replace', :on => :collection
  end


  resources :auction_images, :controller=>'users/auction_images',
    :only=>[:destroy]

  resource :survey, :controller=>'users/surveys',
    :except=>[:show, :destroy] do
    get 'list', :on => :member
  end

  resource :profile, :controller=>'users/profile',
    :only=>[:show, :update , :edit] do
    get 'contact_info' => 'users/profile#contact_info', :as=>"contact_info"
    get "earning_info" => "users/profile#earning_info"
    get "notification" => "users/profile#notification"


    put 'update_notification'=> 'users/profile#update_notification'
    get "invite_friends" => "users/profile#invite_friends"
    get "contact_us" => "users/profile#contact_us"

    patch 'update_contact_info' => 'users/profile#update_contact_info', :as=>"update_contact_info"
    patch 'update_password' => 'users/profile#update_password', :as=>"update_password"
    get 'submit_coupon' => 'users/profile#submit_coupon', :as => 'user_submit_coupon'
    post 'save_coupon' => 'users/profile#save_coupon', :as => 'user_save_coupon'
  end

  resources :funds_withdrawals, :controller => 'users/funds_withdrawals',
    :only => [:index, :create, :new]

  resources :referred_visits, :controller => 'users/referred_visits',
    :only => [:index] do
      get 'referral' => 'users/referred_visits#referral'
      post :get_contact_list, :on=>:collection
      post :send_email_invites, :on=>:collection
  end

  resource :settings, :controller => 'users/settings',
    :except=>[:show, :destroy]

  resources :auctions, :controller=>'vendors/auctions',
    :only=>[:index, :show] do
    get 'search', :on=>:collection
    get 'bid', :on=>:collection
    get 'recommended', :on=>:collection
    get 'latest', :on=>:collection
    get 'finished', :on=>:collection
    get 'saved', :on=>:collection
    get 'won', :on=>:collection
    get 'user', :on=>:member
    get 'new_bid', :on=>:member
    get 'edit_bid', :on=>:member
    post 'create_bid', :on=>:member
    put 'update_bid', :on=>:member
    post 'save', :on=>:member
    post 'unsave', :on=>:member
    get 'outcome', :on=>:member
    put 'update_outcome', :on=>:member
    post 'preview_profile', :on=>:member

  end

  resources :searches, :controller=>'vendors/searches',
    :only=>[:index, :show] do
    get 'active', :on=>:collection
    get 'lost', :on=>:collection
    get 'won', :on=>:collection
  end

  resource :profile, :controller=>'vendors/profile',
    :only=>[:show, :update]

  resource :settings, :controller => 'vendors/settings',
    :except=>[:show, :destroy]

  resources :keywords, :controller => 'vendors/keywords',
    :only =>[:index, :create, :destroy] do
    delete 'destroy_all', :on=>:collection
    post 'import_from_adwords_csv', :on=>:new
  end

  resources :users do
    collection do
      get :single_sign_in
    end
  end
  resources :users, :controller=>'vendors/auctions',
    :only=>[:show]

  resources :campaigns, :controller => 'vendors/campaigns',
    :only => [:index, :create, :destroy, :edit, :update] do
    get 'product', :on=>:new
    get 'service', :on=>:new
    get 'personal', :on=>:new
    get 'pause', :on=>:member
    get 'resume', :on=>:member
    get 'finished_auctions', :on=>:member
  end

  resources :offers, :controller => 'vendors/offers',
    :only => [:index, :create, :destroy, :edit, :update] do
    get 'product', :on=>:new
    get 'service', :on=>:new
    get 'personal', :on=>:new
    post 'upload_image', :on=>:new
    get 'uploaded_images', :on=>:new
    post 'preview', :on=>:new
    put 'preview', :on=>:new
    post 'preview_existing', :on=>:member
    get 'preview_existing', :on=>:member
  end

  resources :personal_offers, :controller => 'vendors/personal_offers',
    :only => [:create, :show] do
    post 'preview', :on=>:new
    put 'preview', :on=>:new
  end


  resources :offer_images, :controller=>'vendors/offer_images',
    :only=>[:destroy]

  resources :funds_transfers, :controller => 'vendors/funds_transfers',
    :only => [:index, :create] do
    get 'confirm', :on=>:member
    post 'execute', :on=>:member
  end

  resources :tracking_events, :controller => 'vendors/tracking_events',
    :only => [:index] do
    post 'create_test', :on=>:collection
    get 'check_test', :on=>:collection
    post 'update_settings', :on=>:collection
    put 'update_settings', :on=>:collection
  end

  match 'funds_refunds/new', :via=>:get, :to=> 'vendors/funds_transfers#new_refund', :as=>'new_funds_refund'
  match 'funds_refunds', :via=>:post, :to=> 'vendors/funds_transfers#create_refund', :as=>'funds_refunds'

  #UNCONSTRAINED ROUTES FOR DIRECT ACCESS
  namespace :users do
    resources :auctions, :controller=>'auctions', :except=>[:edit, :destroy] do
      get 'outcome', :on=>:member
    end

    resource :settings, :controller => 'settings', :except=>[:show, :destroy]
  end


  namespace :company, :module=>"vendors" do
    resources :auctions, :controller=>'auctions', :only=>[:index, :show] do
      get 'outcome', :on=>:member
      put 'update_outcome', :on=>:member
      get 'update_outcome', :on=>:member
      get 'search', :on=>:collection
    end

    resource :settings, :controller => 'settings', :except=>[:show, :destroy]
  end

  match 'track/:event_type' => 'vendors/tracking_events#create', :as=>'create_vendor_tracking_event', via: [:get, :post]

  match '/auth/facebook/callback' => 'vendors/omniauth_callbacks#facebook', via: [:get, :post]
  match '/auth/twitter/callback' => 'vendors/omniauth_callbacks#twitter', via: [:get, :post]
  match '/auth/google_oauth2/callback' => 'vendors/omniauth_callbacks#google_oauth2', via: [:get, :post]

  match '/auth/failure' => 'vendors/omniauth_callbacks#failure', via: [:get, :post]

  match 'load_product_categories' => 'application#load_product_categories', via: [:get, :post]
  # match 'check_sample_offers' => 'application#check_sample_offers', :via => :post
  match 'check_sample_offers_avant' => 'application#check_sample_offers_avant', :via => :post
  match 'check_sample_offers_cj' => 'application#check_sample_offers_cj', :via => :post


  #admin zone
  namespace :admin, :module=>"admins" do
    resources :categories
    resources :users, :controller=> 'users', :path => "customers",
      :only=>[:index, :show, :destroy, :edit, :update] do
      get 'customer_reffer', :on=>:collection
      get 'customer_favourite_merchants', :on=> :collection
      get 'download_csv_file_customer_reffer', :on=>:collection
      get 'download_csv_file_customer_favourite_merchant', :on=>:collection
      get 'download_csv_file_loyalty_programs_user', :on=>:collection
      get 'loyalty_programs_user', :on=>:collection
      get 'withdraw', :on=>:member
      get 'purchase', :on=>:member
      put 'block', :on=>:member
      put 'unblock', :on=>:member
      get 'become', :on=>:member
      put 'become_sales_owner', :on=>:member
      put 'become_not_sales_owner', :on=>:member
      post 'add_money', :on=>:member
      get 'download_csv', :on => :collection, :format=>'csv'
      get 'searches/:search_intent_id', :on=>:member, :action => 'show_search'
      get 'release/:intent_outcome_id', :on=>:member, :action => 'release_money'
      post 'release/:intent_outcome_id', :on=>:member, :action => 'release_money'
      get 'activate/:merchant_id', :on=>:member, :action => 'make_merchant_active'
      get 'activate/:merchant_id', :on=>:member, :action => 'make_merchant_active'
    end

    resources :payment_histories

    resources :custom_advertisers, :controller=> 'custom_advertisers'

    resources :withdrawal_requests, :controller=> 'withdrawal_requests', :only=>[:index, :show]

    resources :add_storecat_to_merchant, :controller=> 'add_storecat_to_merchant', :constraints => true,:only=>[:index] do
      get "get_merchants_list", :on => :collection
      get "get_selected_merchants_list", :on => :collection
      delete "remove_selected_merchant", :on => :collection
      post "add_merchant", :on => :collection

    end

    resources :hp_stores, :controller=> 'hp_stores',  :only=>[:index, :show, :destroy, :create] do
      post "replace_hp_store", :on => :collection
      get "add_custom_store_logo", :on => :collection
      post "create_custom_store_logo", :on => :collection
      get "edit_custom_store_logo", :on => :collection
      put "update_custom_store_logo", :on => :collection
      patch "save_high_resolution_image", :on => :collection
    end

    resources :hp_store_product_categories, :controller=> 'hp_store_product_categories',  :only=>[:index, :show, :destroy, :create] do
    end
    resources :review_submitted_coupons, :controller=> 'review_submitted_coupons',  :only=>[:index, :show, :destroy, :create] do
    end

    resources :stores, :controller=> 'stores', :only=>[:index, :show] do
      post 'avant_stores', :on => :collection
      post 'ls_stores', :on => :collection
      post 'cj_stores', :on => :collection
      post 'pj_stores', :on => :collection
      post 'ir_stores', :on => :collection
    end

    resources :vendors, :controller=> 'vendors', :path => "companies",
      :only=>[:index, :show] do
      put 'block', :on=>:member
      put 'unblock', :on=>:member
      post 'create_funds_grant', :on=>:member
    end

    resources :auctions, :controller=> 'auctions',
      :only=>[:index, :show]

    resources :finance, :controller=> 'finance',
              :only=>[:index]

    resources :outcome_reports, :only=>[:index] do
      collection do
        get 'release/:intent_outcome_id', :action => 'release_money'
        post 'release/:intent_outcome_id', :action => 'release_money'
      end
    end

    get 'revenue_daily_report' => 'finance#revenue_daily_report', :as=>'overall_revenue_daily_report'
    get 'revenue_day_report' => 'finance#revenue_day_report', :as=>'overall_revenue_day_report'

    resources :email_contents, :controller => 'email_contents',
      :only=>[:index, :edit, :update] do
      post 'preview', :on=>:member
    end

    resources :box_messages, :controller => 'box_messages', :only => [:index, :create]
    get 'sales_links' => 'sales_links#index', :as=>'sales_links'
    post 'sales_links/assign_user' => 'sales_links#assign_user', :as=>'sales_links_assign_user'
    get 'sales_links/:group_id' => 'sales_links#show_group', :as=>'sales_links_show_group'
    get 'revenue_report/:user_id' => 'sales_links#revenue_report', :as=>'revenue_report'
    get 'revenue_daily_report/:user_id' => 'sales_links#revenue_daily_report', :as=>'revenue_daily_report'
    get 'revenue_day_report/:user_id' => 'sales_links#revenue_day_report', :as=>'revenue_day_report'

#    get 'purchase_history' => 'purchase_history#index', :as=>'purchase_history'
    resources :purchase_histories, only: [:index, :show]

    resources :affiliated_advertisers,
      :only=>[:index] do
      get 'cj_coupons', :on => :collection, :format=>'csv'
      get 'cj_auto_downloaded_coupons', :on => :collection, :format=>'csv'
      get 'avant_coupons', :on => :collection, :format=>'csv'
      get 'avant_auto_downloaded_coupons', :on => :collection, :format=>'csv'
      get 'linkshare_coupons', :on => :collection, :format=>'csv'
      get 'linkshare_auto_downloaded_coupons', :on => :collection, :format=>'csv'
      get 'affiliates_categories', :on => :collection
      get 'cj_advertisers', :on => :collection, :format=>'csv'
      get 'avant_advertisers', :on => :collection, :format=>'csv'

      get 'linkshare_advertisers', :on => :collection, :format=>'csv'

      get 'pj_advertisers', :on => :collection, :format=>'csv'
      get 'pj_coupons', :on => :collection, :format=>'csv'
      get 'pj_auto_downloaded_coupons', :on => :collection, :format=>'csv'

      get 'ir_advertisers', :on => :collection, :format=>'csv'
      get 'ir_coupons', :on => :collection, :format=>'csv'
      get 'ir_auto_downloaded_coupons', :on => :collection, :format=>'csv'

      get 'download_user_data', :on => :collection, :format=>'csv'

      get 'cj_fetch_coupons_manually', :on => :collection
      get 'avant_fetch_coupons_manually', :on => :collection
      get 'linkshare_fetch_coupons_manually', :on => :collection
      get 'pj_fetch_coupons_manually', :on => :collection
      get 'ir_fetch_coupons_manually', :on => :collection

      get 'cj_api_coupons', :on => :collection, :format=>'csv'
      post 'cj_coupons_from_csv', :on=>:collection
      post 'avant_coupons_from_csv', :on=>:collection
      post 'linkshare_coupons_from_csv', :on=>:collection
      post 'pj_coupons_from_csv', :on=>:collection
      post 'ir_coupons_from_csv', :on=>:collection

      post 'set_source_category_to_copy_mappings', :on=>:collection
      post 'copy_mappings_to_current_category', :on=>:collection

      collection do
        match 'product_category/:product_category_id' => "affiliated_advertisers#product_category_affiliates", :via => :get, :as => "product_category_affiliates"
        match 'product_category/:product_category_id' => "affiliated_advertisers#update_product_category_affiliates", :via => :put, :as => "update_product_category_affiliates"
        match 'add_affiliate_mapping/:product_category_id/:type/:advertiser_id' => "affiliated_advertisers#add_affiliate_mapping", :via => :get, :as => "add_affiliate_mapping"
        match 'remove_affiliate_mapping/:type/:id' => "affiliated_advertisers#remove_affiliate_mapping", :via => :get, :as => "remove_affiliate_mapping"
        match 'toggle_affiliate_mapping_preferred/:type/:id' => "affiliated_advertisers#toggle_affiliate_mapping_preferred", :via => :get, :as => "toggle_affiliate_mapping_preferred"
      end
    end


  end

  # referral links
  match 'ref_id/:referring_user_id' => 'welcome#index', :as=>:referred_by_user, via: [:get, :post]
  match ':referring_user_id_or_group_name' => 'application#index', via: [:get, :post]


  # Must be last
  unless Rails.application.config.consider_all_requests_local
     match '*not_found', :to => 'errors#error_404', via: :get
  end

end