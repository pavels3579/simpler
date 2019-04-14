require 'logger'

class AppLogger

  def initialize(app)
    @app = app
    @logger = Logger.new('log/app.log')
  end

  def call(env)
    status, headers, response = @app.call(env)
    log_message = format_log_message(env, status, headers)
    @logger.info(log_message)
    [status, headers, response]
  end

  private

  def format_log_message(env, status, headers)
    output = ["\n"]
    output << "Request: #{env['REQUEST_METHOD']} #{env['REQUEST_URI']}"
    output << "Handler: #{env['simpler.controller'].class}##{env['simpler.action']}"
    output << "Parameters: #{env['simpler.request_params']}"
    output << "Response: #{status} [#{headers['Content-Type']}] #{env['simpler.view']}"
    output.join("\n")
  end
end
