rails_env = ENV['RAILS_ENV'] || 'production'

app_dir = "/app"

working_directory app_dir

pid "#{app_dir}/tmp/unicorn.pid"

stderr_path "#{app_dir}/log/unicorn.stderr.log"
stdout_path "#{app_dir}/log/unicorn.stdout.log"

worker_processes (rails_env == 'production' ? 2 : 2)

listen "/tmp/unicorn.sock", :backlog => 128

# Load rails+github.git into the master before forking workers
# for super-fast worker spawn times
preload_app true

# test with long timeout for scalable apps
# creation
timeout 30
