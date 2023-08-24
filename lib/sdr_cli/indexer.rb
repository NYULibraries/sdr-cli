require "geo_combine/indexer"

module SdrCli
  class Indexer
    def initialize(solr_url:)
      @solr_url = solr_url
    end

    def index(dir_glob, commit_within: ENV.fetch("SOLR_COMMIT_WITHIN", 5000).to_i)
      docs = Dir[dir_glob].map { |file| JSON.parse(File.read(file)) }
      fix_solr_geom_key(docs)
      indexer.index(docs, commit_within: commit_within)
    end

    private

    def indexer
      @indexer ||= GeoCombine::Indexer.new(solr: solr)
    end

    def solr
      @solr ||= GeoCombine::Indexer.solr(url: @solr_url)
    end

    # THIS IS HOPEFULLY TEMPORARY AS THIS PR IS IN FLIGHT - https://github.com/OpenGeoMetadata/GeoCombine/pull/143
    def fix_solr_geom_key(docs)
      docs.each do |doc|
        doc.transform_keys! { |key| (key == "solr_geom") ? "dct_bbox" : key }
      end
    end
  end
end
