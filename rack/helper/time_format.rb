class TimeFormat

  attr_reader :formatted_time

  AVAILABLE_FORMATS = {
  'year'    => '%Y',
  'month'   => '%m',
  'day'     => '%d',
  'hour'    => '%H',
  'minute'  => '%M',
  'second'  => '%S'
  }

  def call(params)
    @formatted_time = []
    @invalid_formats = []
    formats = params.split(",")

    time_check(formats)
    return wrong_format unless @invalid_formats.empty?
  end

  def time_check(formats)
    time = []
    formats.each do |format|
      AVAILABLE_FORMATS.has_key?(format) ? time << Time.now.strftime(AVAILABLE_FORMATS[format]) : @invalid_formats << format
    end
    @formatted_time = time.join("-")
  end

  def wrong_format
    @wrong_format = true
    @formatted_time = "Unknown time format: #{@invalid_formats}\n"
  end

  def wrong_format?
    @wrong_format
  end

end
