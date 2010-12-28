require 'dima_app_logger'
require 'rails'

module DimaAppLogger
  class Railtie < Rails::Railtie
    railtie_name :dima_app_logger

    rake_tasks do
      load "tasks/app_logger.rake"
    end
  end
end

