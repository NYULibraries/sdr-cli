# frozen_string_literal: true

require_relative "sdr_cli/version"
require_relative "sdr_cli/web_feature_service_client"
require_relative "sdr_cli/web_map_service_client"
require_relative "sdr_cli/fetcher"
require_relative "sdr_cli/transformer"
require_relative "sdr_cli/indexer"
require_relative "sdr_cli/auditor"
require_relative "sdr_cli/cli"

module SdrCli
  require "dotenv"
  Dotenv.load
  class Error < StandardError; end
  # Your code goes here...
end
