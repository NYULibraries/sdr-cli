# frozen_string_literal: true

require "sdr_cli"
require "solr_wrapper"

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

  config.around(:each, type: :solr) do |example|
    shared_solr_opts = {managed: true, verbose: true, persist: false, download_dir: "tmp"}
    shared_solr_opts[:version] = ENV["SOLR_VERSION"] if ENV["SOLR_VERSION"]

    SolrWrapper.wrap(shared_solr_opts.merge(port: ENV["SOLR_PORT"], instance_dir: ENV["SOLR_INSTANCE_DIR"])) do |solr|
      solr.with_collection(name: ENV["SOLR_INSTANCE_NAME"], dir: "solr/conf") do
        example.run
      end
    end
  end
end
