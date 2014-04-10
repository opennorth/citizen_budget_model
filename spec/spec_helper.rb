require 'spork'

Spork.prefork do
  ENV["RAILS_ENV"] ||= 'test'

  require 'rails/application'
  # Prevent Spork from caching the routes.
  Spork.trap_method(Rails::Application::RoutesReloader, :reload!)
  # Prevent Spork from caching the engine's classes (see below).
  Spork.trap_method(Rails::Application, :eager_load!)

  require File.expand_path("../dummy/config/environment.rb",  __FILE__)
  require 'rspec/rails'

  Rails.backtrace_cleaner.remove_silencers!

  Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

  # Prevent Spork from caching the engine's classes (see above).
  Rails.application.railties.all do |railtie|
    unless railtie.respond_to?(:engine_name) && railtie.engine_name == 'citizen_budget_model'
      railtie.eager_load!
    end
  end

  require 'database_cleaner'
  require 'factory_girl_rails'

  RSpec.configure do |config|
    config.mock_with :rspec

    config.after(:each) do
      DatabaseCleaner.clean
    end

    # http://railscasts.com/episodes/285-spork
    config.treat_symbols_as_metadata_keys_with_true_values = true
    config.run_all_when_everything_filtered = true
    config.filter_run focus: true
  end
end

Spork.each_run do
  # It's now okay to load the engine.
  Rails.application.railties.engines.each do |engine|
    if engine.engine_name == 'citizen_budget_model'
      engine.eager_load!
    end
  end

  # @todo I18n.backend.reload!
  FactoryGirl.reload
end
