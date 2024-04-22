require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module App
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # for Microsoft Graph Notify
    config.hosts << ENV.fetch('BACKEND_HOST') { 'localhost' } if Rails.env.production?
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    config.time_zone = 'Asia/Tokyo'
    config.active_record.default_timezone = :local
    config.eager_load_paths << Rails.root.join("#{config.root}/lib/")
    config.eager_load_paths << Rails.root.join("#{config.root}/lib/**/")

    # queue_adapter
    config.active_job.queue_adapter = :sidekiq
  end
end
