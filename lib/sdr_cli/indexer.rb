require "geo_combine/indexer"

module SdrCli
  class Indexer
    def initialize(solr_url:)
      @solr_url = solr_url
    end

    def index(dir_glob, commit_within: ENV.fetch("SOLR_COMMIT_WITHIN", 5000).to_i)
      files = Dir[dir_glob]
      docs = files.map { |file| JSON.parse(File.read(file)) }
      indexer.index(docs, commit_within: commit_within)
    end

    private

    def indexer
      @indexer ||= GeoCombine::Indexer.new(solr: solr)
    end

    def solr
      @solr ||= GeoCombine::Indexer.solr(url: @solr_url)
    end
  end
end
