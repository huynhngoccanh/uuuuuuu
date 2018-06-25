desc 'Issue payments to customers who placed request during the time of when system balance is zero.'

task :execute_withdrawal_request => :environment do
  FundsWithdrawal.process_delayed_withdrawals
end

