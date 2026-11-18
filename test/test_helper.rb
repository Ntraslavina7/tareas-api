# SimpleCov debe iniciarse ANTES de cargar la app, para medir todo el código.
require "simplecov"
SimpleCov.start "rails" do
  enable_coverage :branch
  skip %w[/bin/ /config/ /db/ /test/ /vendor/]
end

ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Carga todos los fixtures de test/fixtures/*.yml
    fixtures :all
  end
end
