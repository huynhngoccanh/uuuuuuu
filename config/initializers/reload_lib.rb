#if Rails.env == "development"
#  # lib_reloader = ActiveSupport::FileUpdateChecker.new("app/models/api.rb", true) do
#  #   Rails.application.reload_routes! # or do something better here
#  # end
#
#  ActionDispatch::Callbacks.to_prepare do
##    lib_reloader.execute_if_updated
#  end
#end
