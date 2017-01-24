require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ReactRails
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    
      # Include the authenticity token in remote forms.
    config.action_view.embed_authenticity_token_in_remote_forms = true

    #Rspec
    config.generators do |g|
      g.test_framework :rspec,
      :fixtures => true,
      :view_specs => false,
      :helper_specs => false,
      :routing_specs => true,
      :controller_specs => true,
      :request_specs => true
      g.fixture_replacement :factory_girl, :dir => "spec/factories"
    end

    config.react.addons = true
  end
end
