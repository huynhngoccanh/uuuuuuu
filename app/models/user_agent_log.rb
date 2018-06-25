class UserAgentLog < ActiveRecord::Base
  LOG_COUNT = 10

  belongs_to :user
end
