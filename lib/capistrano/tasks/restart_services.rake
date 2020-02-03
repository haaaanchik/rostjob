namespace :deploy do
  after :finished, :restart_services
  desc 'Restart nginx Unicorn, Resque-Scheduler, Resque-Worker'
  task :restart_services do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      execute "sudo systemctl restart stage-rostjob_unicorn"
      execute "sudo systemctl restart stage-rostjob_job_scheduler"
      execute "sudo systemctl restart stage-rostjob_job_worker"
      execute "sudo systemctl restart rostjob_unicorn"
      execute "sudo systemctl restart rostjob_job_scheduler"
      execute "sudo systemctl restart rostjob_job_worker"
      execute "sudo systemctl restart nginx"
    end
  end
end
