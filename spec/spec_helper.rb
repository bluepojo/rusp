require 'rubygems'
require 'bundler'
require 'rspec'
require 'rusp'
require 'spork'
require 'pp'

def setup_rspec
  Dir[File.join(File.expand_path("../../spec/support/**/*.rb", __FILE__))].each { |f| require f }

  RSpec.configure do |config|
    config.mock_with :rspec
    config.treat_symbols_as_metadata_keys_with_true_values = true
    config.filter_run focus: true
    config.run_all_when_everything_filtered = true
  end
end

Spork.prefork do
  setup_rspec
end

Spork.each_run do
  require 'rusp'
end
