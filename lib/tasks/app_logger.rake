require 'fileutils'

namespace :app_logger do
  desc "rotate logs"
  task :rotate do
    day_secs = 60 * 60 * 24
    tm = Time.now.utc
    tm = Time.utc(tm.year, tm.month, tm.day).to_i
    format_re = Dima::AppLogger::DIR_FORMAT.gsub(/\:year/, '([0-9]{4})')
    format_re = format_re.gsub(/\:month/, '([0-9]{2})')
    format_re = format_re.gsub(/\:day/, '([0-9]{2})')
    format_re = /^#{format_re}(\.tar\.gz)?$/
    log_dir = File.expand_path(Dir.pwd + "/log/")
    items = Pathname.glob(log_dir + "/*").map{|i| i.basename.to_s }
    items.each do |it|
      # fixed positions year, month, day, archive
      if re = format_re.match(it)
        year = $1.to_i
        month = $2.to_i
        day = $3.to_i
        arc = !!$4
        timestamp = Time.utc(year, month, day).to_i
        days = (tm - timestamp) / day_secs
        if days > 7
          FileUtils.rm_r(log_dir + "/#{it}")
        elsif days >= 1 && !arc
          `(cd #{log_dir} && tar -zcf #{it}.tar.gz #{it} && rm -r #{it})`
        end
      end
    end
  end
end
