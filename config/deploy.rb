lock '~> 3.11.0'

set :application, 'rostjob'
set :repo_url, 'git@git.handshead.com:rostjob/rostjob.git'

append :linked_files, 'config/master.key', 'config/database.yml', 'config/credentials.yml.enc'
append :linked_dirs, 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'public/system'

set :keep_releases, 3
after 'deploy:finished', 'sitemap:refresh'
