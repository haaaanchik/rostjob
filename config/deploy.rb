lock '~> 3.11.0'

set :application, 'rostjob'
set :repo_url, 'git@bitbucket.org:Factory-Rushers/rostjob.git'

append :linked_files, 'config/master.key', 'config/database.yml'
append :linked_dirs, 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'public/system'

set :keep_releases, 3
