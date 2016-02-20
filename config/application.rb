require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SubwayTube
  class Application < Rails::Application

    config.active_record.raise_in_transactional_callbacks = true

    config.assets.paths << "#{Rails.root}/app/assets/fonts"

    config.x.custom_vars = Rails.application.config_for :custom_vars

  end
end
