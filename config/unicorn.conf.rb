app_dir = File.expand_path("../..", __FILE__)
shared_dir = "#{app_dir}/shared"
working_directory File.join(app_dir, 'ubitru')


# Set unicorn options
worker_processes 2

preload_app true
timeout 30

# Set up socket location
listen '127.0.0.1:4000'
listen "#{shared_dir}/sockets/unicorn.sock", :backlog => 64

# Logging
stderr_path "#{shared_dir}/log/unicorn.stderr.log"
stdout_path "#{shared_dir}/log/unicorn.stdout.log"

# Set master PID location
pid "#{shared_dir}/pids/unicorn.pid"

