# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

set :output, 'log/cron.log'

every 8.hours do
  rake 'reload_all_coupons'
end

every 30.minutes do
 rake 'affiliate_fetch_new_commissions'
end

# every 1.day do
#  rake 'reload_all_advertisers'
#  rake 'cj_fetch_advertisers_logos'
#  rake 'clear_inactive_sessions'
#  rake 'execute_withdrawal_request'
# end

# every 8.hours do
#   rake 'reload_all_coupons'
# end

# every 1.minute do
#   rake 'schedular_test_on_production'
# end
