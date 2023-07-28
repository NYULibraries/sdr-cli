# frozen_string_literal: true

require "sdr_cli"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  # Don't show pending tests in output
  config.filter_run_excluding skip: true

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end