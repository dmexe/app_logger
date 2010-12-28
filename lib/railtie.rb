require 'dima_app_logger'
require 'rails'

module DimaAppLogger
  class Railtie < Rails::Railtie
    railtie_name :dima_app_logger

    rake_tasks do
      load "tasks/my_plugin.rake"
    end
  end
end

