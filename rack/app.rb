require_relative 'helper/time_format'

class App

  def call(env)
    request = Rack::Request.new(env)
    response = Rack::Response.new
    response['Content-Type'] = 'text/plain'
    time_format(request.params, response)
    response.finish
  end

  private

  def time_format(params, response)
    if params.has_key?('format')
      format = TimeFormat.new
      format.call(params['format'])
      if format.wrong_format?
        response.status = 400
        response.body = [format.formatted_time]
      else
        response.status = 200
        response.body = [format.formatted_time]
      end
    else
      response.status = 404
      response.body = ['Not Found']
    end
  end

end
