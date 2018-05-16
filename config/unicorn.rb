# set path to application
app_dir = File.expand_path("../..", __FILE__)
tmp_dir = "#{app_dir}/tmp"
log_dir = "#{app_dir}/log"
working_directory app_dir


# Set unicorn options
worker_processes 2
preload_app true
timeout 30

# Set up socket location
listen "#{tmp_dir}/sockets/unicorn.sock", :backlog => 64

# Logging
stderr_path "#{log_dir}/unicorn.stderr.log"
stdout_path "#{log_dir}/unicorn.stdout.log"

# Set master PID location
pid "#{tmp_dir}/pids/unicorn.pid"

before_fork do |server, worker|
  # Disconnect since the database connection will not carry over
  ActiveRecord::Base.connection.disconnect! if defined?(ActiveRecord::Base)

  Signal.trap 'TERM' do
    puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
    Process.kill 'QUIT', Process.pid
  end

  if defined?(Resque)
    Resque.redis.quit
    Rails.logger.info('Disconnected from Redis')
  end

  old_pid = "#{server.config[:pid]}.oldbin"
  if old_pid != server.pid
    begin
      sig = (worker.nr + 1) >= server.worker_processes ? :QUIT : :TTOU
      Process.kill(sig, File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
    end
  end
end

after_fork do |server, worker|
  # Start up the database connection again in the worker
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.establish_connection
  end

  if defined?(Resque)
    Resque.redis = ENV['REDIS_URI']
    Rails.logger.info('Connected to Redis')
  end

  worker.user('zerro', 'zerro')
end