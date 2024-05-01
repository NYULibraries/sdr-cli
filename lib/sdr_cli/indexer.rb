require "geo_combine/indexer"

module SdrCli
  class Indexer
    attr_reader :schema_version

    def initialize(solr_url:, schema_version: "Aardvark")
      @solr_url = solr_url
      @schema_version = schema_version
    end

    def index(directory, commit_within: ENV.fetch("SOLR_COMMIT_WITHIN", 5000).to_i)
      docs = harvester(directory).docs_to_index.to_a
      indexer.index(docs, commit_within: commit_within)
    end

    private

    def indexer
      @indexer ||= GeoCombine::Indexer.new(solr: solr)
    end

    def solr
      @solr ||= GeoCombine::Indexer.solr(url: @solr_url)
    end

    private

    def harvester(directory)
      @harvester ||= ::GeoCombine::Harvester.new(schema_version: schema_version, ogm_path: directory)
    end
  end
end
