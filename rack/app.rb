class App

  def call(env)
    query_check(env['QUERY_STRING'])
  end

  private

  def query_check(query_string)
    format = query_string.gsub(/(=|%2C)/, "|").split("|")
    return not_found unless format.shift == "format"

    invalid_formats = []
    body = ""

    format.each do |time|
      result = time_check(time)
      if result.is_a?(Integer)
        time == format.last ? body += "#{result}\n" : body += "#{result}" + "-"
      else
        invalid_formats << result[1]
      end
    end

    return format_error(invalid_formats) unless invalid_formats.empty?

    [ok_status, headers, [body]]
  end

  def time_check(format)
    case format
      when "year"
        Time.now.year
      when "month"
        Time.now.month
      when "day"
        Time.now.day
      when "hour"
        Time.now.hour
      when "minute"
        Time.now.min
      when "second"
        Time.now.sec
      else
        [:invalid, format]
    end
  end

  def format_error(invalid_formats)
    body = ["Unknown time format: #{invalid_formats}\n"]
    status = 400
    [status, headers, body]
  end

  def not_found
    status = 404
    body = ["Not Found\n"]
    [status, headers, body]
  end

  def ok_status
    200
  end

  def headers
    { 'Content-Type' => 'text/plain' }
  end

end
