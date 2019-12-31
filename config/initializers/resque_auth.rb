Resque::Server.use(Rack::Auth::Basic) do |user, password|
  user == 'admin' && password == 'rostjob123'
end
