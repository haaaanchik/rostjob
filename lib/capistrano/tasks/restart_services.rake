namespace :deploy do
  after :finished, :restart_services
  desc 'Restart nginx Unicorn, Resque-Scheduler, Resque-Worker'
  task :restart_services do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      if ENV['RAILS_ENV'] == 'staging'
        execute "sudo systemctl restart stage-best-hr_unicorn"
        execute "sudo systemctl restart stage-best-hr_job_scheduler"
        execute "sudo systemctl restart stage-best-hr_job_worker"
      end
      execute "sudo systemctl restart jobny-ru_unicorn"
      execute "sudo systemctl restart jobny-ru_job_scheduler"
      execute "sudo systemctl restart jobny-ru_job_worker"
      execute "sudo systemctl restart nginx"
    end
  end
end
