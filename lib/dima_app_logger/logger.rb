require 'fileutils'
require 'logger'

module Dima
	class AppLogger
		DIR_FORMAT = ":year:month:day"
		attr_accessor :_options

		def initialize(options = {})
			self._options = {}
			self._options[:root] = options[:root]
			self._options[:env]  = options[:env]
			self._options[:name] = options[:name] || ENV["APP_LOGGER_NAME"]
			if defined?(Rails)
				self._options[:root] ||= Rails.root
				self._options[:env]  ||= Rails.env
			end
			self._options[:env]  ||= "development"
			self._options[:root] ||= Dir.pwd
			self._options[:dir_format] = _make_dir_format(DIR_FORMAT)
			_expire!
		end

		def _make_dir_format(format)
			format.gsub(":year", '%Y').gsub(/:month/, '%m').gsub(/:day/, '%d')
		end

		def _logger
			unless @logger
				@logger = if _options[:env] == "test"
										_create_test_logger
									elsif (ENV["_"] =~ /irb/ || ENV["APP_LOGGER_STDOUT"]) && !ENV["APP_LOGGER_NOSTDOUT"]
										_create_stdout_logger
									else
										_create_app_logger
									end
			end
			@logger
		end

		def _create_app_logger
			name = _options[:env] + "." + (_options[:name] && "#{_options[:name]}.").to_s + _options[:pid].to_s + ".log"
			name = File.join(self._options[:root], "log", _date_string, name)
			_mkdir(name)
			AppLoggerInstance.new(name)
		end

		def _create_test_logger
			name = File.join(_options[:root], "log", "test.log")
			_mkdir(name)
			AppLoggerInstance.new(name)
		end

		def _create_stdout_logger
			AppStdoutLoggerInstance.new
		end

		def _expired?
			tm = Time.now.utc
			rs = _options[:pid]         != Process.pid || 
						_options[:time].day   != tm.day      ||
						_options[:time].month != tm.month    ||
						_options[:time].year  != tm.year
			tm = nil
			rs
		end

		def _expire!
			self._options[:pid]  = Process.pid
			self._options[:time] = Time.now.utc
			if @logger
				@logger.close if @logger.respond_to?(:close)
				@logger = nil
			end
		end

		def _date_string
			_options[:time].strftime(_options[:dir_format])
		end

		def _mkdir(path)
			FileUtils.mkdir_p(File.dirname(path))
		end

		def method_missing(method, *args, &block)
			_expire! if _expired?
			_logger.__send__(method, *args, &block)
		end
	end

	class AppLoggerInstance < ::Logger
		def format_message(level, time, progname, msg) 
			tm = time.utc.strftime("%Y/%m/%d %H:%M:%S") + "." + ("%.03d" % (time.usec / 1000))
			"#{tm} UTC [#{level.split(//)[0]}] -- #{msg}\n"
  	end  
	end

	class AppStdoutLoggerInstance < ::Logger
		def initialize
			super(STDOUT)
		end
	end
end
