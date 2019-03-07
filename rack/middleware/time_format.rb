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
    @invalid_formats = []
    params = Rack::Request.new(env).params
    formats = params["format"].split(",")
    return not_found unless params.has_key?("format")

    @body = [time_check(formats)]
    @status = OK_STATUS
    return format_error unless @invalid_formats.empty?
    [@status, headers, @body]
  end

  def time_check(formats)
    body = []
    formats.each do |format|
      AVAILABLE_FORMATS.has_key?(format) ? body << Time.now.strftime(AVAILABLE_FORMATS[format]) : @invalid_formats << format
    end
    body.join("-")
  end

  def format_error
    @body = ["Unknown time format: #{@invalid_formats}\n"]
    @status = 400
    [@status, headers, @body]
  end

  def not_found
    @status = 404
    @body = ["Not Found\n"]
    [@status, headers, @body]
  end

  def headers
    { 'Content-Type' => 'text/plain' }
  end
end
