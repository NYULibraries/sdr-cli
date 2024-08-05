require "geo_combine/indexer"

module SdrCli
  class Indexer
    def initialize(solr_url:)
      @solr_url = solr_url
    end

    def index(dir_glob)
      files = Dir[dir_glob]
      docs = files.map { |file| JSON.parse(File.read(file)) }
      indexer.index(docs)
    end

    private

    def indexer
      @indexer ||= GeoCombine::Indexer.new(solr: RSolr.connect(url: @solr_url))
    end
  end
end
