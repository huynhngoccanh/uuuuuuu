Delayed::Worker.delay_jobs = !Rails.env.test?

#ensure delayed job deamon is running taken from 
#http://stackoverflow.com/questions/2580871/start-or-ensure-that-delayed-job-runs-when-an-application-server-restarts

DELAYED_JOB_PID_PATH = "#{Rails.root}/tmp/pids/delayed_job.pid"
Delayed::Worker.logger = Logger.new(File.join(Rails.root, 'log', 'dj.log'))

def start_delayed_job
  Thread.new do 
    `ruby bin/delayed_job start`
  end
end

def process_is_dead?
  begin
    pid = File.read(DELAYED_JOB_PID_PATH).strip
    Process.kill(0, pid.to_i)
    false
  rescue
    true
  end
end

if Rails.env.production? && !File.exist?(DELAYED_JOB_PID_PATH) && process_is_dead?
  start_delayed_job
end
