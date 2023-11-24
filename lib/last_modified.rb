# frozen_string_literal: true

class LastModified
  def initialize(app)
    @app = app
  end

  def call(env)
    status, headers, response = @app.call(env)
    headers['Last-Modified'] = Time.now.httpdate
    [status, headers, response]
  end
end
