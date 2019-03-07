class TimeFormat

  AVAILABLE_FORMATS = {
  'year'    => '%Y',
  'month'   => '%m',
  'day'     => '%d',
  'hour'    => '%H',
  'minute'  => '%M',
  'second'  => '%S'
  }

  OK_STATUS = 200

  def initialize(app)
    @app = app
  end

  def call(env)
    params = Rack::Request.new(env).params
    @response = Rack::Response.new
    @response['Content-Type'] = 'text/plain'

    @invalid_formats = []
    formats = params["format"].split(",")
    return not_found unless params.has_key?("format")

    @body = [time_check(formats)]
    @status = OK_STATUS
    return format_error unless @invalid_formats.empty?
    @response.status = 200
    @response.body = @body
    @response.finish
  end

  def time_check(formats)
    body = []
    formats.each do |format|
      AVAILABLE_FORMATS.has_key?(format) ? body << Time.now.strftime(AVAILABLE_FORMATS[format]) : @invalid_formats << format
    end
    body.join("-")
  end

  def format_error
    @response.body = ["Unknown time format: #{@invalid_formats}\n"]
    @response.status = 400
    @response.finish
  end

  def not_found
    @response.status = 404
    @response.body = ["Not Found\n"]
    @response.finish
  end
end
