require_relative 'view'

module Simpler
  class Controller

    attr_reader :name, :request, :response

    CONTENT_TYPES = { plain: 'text/plain', html: 'text/html' }.freeze

    def initialize(env)
      @name = extract_name
      @request = Rack::Request.new(env)
      @response = Rack::Response.new

    end

    def make_response(action)
      @request.env['simpler.controller'] = self
      @request.env['simpler.action'] = action

      set_default_headers
      send(action)
      write_response

      @response.finish
    end

    def headers(key, value)
      @response.set_header(key, value)
    end

    def status(number)
      @response.status = number
    end

    private

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end

    def set_default_headers
      @response['Content-Type'] ||= CONTENT_TYPES[render_content_type]
    end

    def render_content_type
      @request.env['simpler.template'].nil? ? :html : @request.env['simpler.template'].keys.first
    end

    def write_response
      body = render_body

      @response.write(body)
    end

    def render_body
      View.new(@request.env).render(binding)
    end

    def params
      @request.params
    end

    def render(template)
      @request.env['simpler.template'] = template
    end

  end
end
