require "bundler/setup"
require "alphavantage"
require "webmock/rspec"
require "support/file_fixture"
require "byebug"

RSpec.configure do |config|
  config.include FileFixture

  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # Disable the need to prefix `describe` with `RSpec.`
  # https://relishapp.com/rspec/rspec-core/v/3-0/docs/configuration/global-namespace-dsl
  config.expose_dsl_globally = true
end
