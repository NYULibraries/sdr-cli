require "geo_combine"
require "geo_combine/harvester"

module SdrCli
  class Fetcher
    attr_reader :ogm_path, :schema_version, :repo

    def initialize(ogm_path:, schema_version:, repo: nil)
      @ogm_path = ogm_path
      @schema_version = schema_version
      @repo = repo
    end

    def clone
      repo ? harvester.clone(repo) : harvester.clone_all
    end

    def pull
      repo ? harvester.pull(repo) : harvester.pull_all
    end

    private

    def harvester
      @harvester ||= ::GeoCombine::Harvester.new(ogm_path: ogm_path,
        schema_version: schema_version)
    end
  end
end
