require "geo_combine/indexer"

module SdrCli
  class Indexer
    def initialize(solr_url:, schema_version: "Aardvark")
      @solr_url = solr_url
      @schema_version = schema_version
    end

    def index(directory)
      docs = harvester(directory).docs_to_index.to_a
      indexer.index(docs)
    end

    private

    def indexer
      @indexer ||= GeoCombine::Indexer.new(solr: RSolr.connect(url: @solr_url))
    end

    def harvester(directory)
      @harvester ||= ::GeoCombine::Harvester.new(schema_version: @schema_version, ogm_path: directory)
    end
  end
end
