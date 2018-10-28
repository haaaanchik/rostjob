namespace :deploy do
  after :finished, :restart_services
  desc 'Restart nginx Unicorn, Resque-Scheduler, Resque-Worker'
  task :restart_services do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      execute "sudo systemctl restart best-hr_unicorn"
      execute "sudo systemctl restart best-hr_job_scheduler"
      execute "sudo systemctl restart best-hr_job_worker"
      execute "sudo systemctl restart nginx"
    end
  end
end
