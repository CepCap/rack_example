require_relative 'middleware/time_format'
require_relative 'app'

use TimeFormat
run App.new
