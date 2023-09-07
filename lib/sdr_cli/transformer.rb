require "geo_combine/migrators/v1_aardvark_migrator"

module SdrCli
  class Transformer
    attr_reader :directory, :destination

    def initialize(directory:, destination:)
      @directory = directory
      @destination = destination
    end

    def run
      docs = Dir["#{directory}/**/*.json"]
      new_docs = transform_collection(docs)
      save_to_destination(new_docs)
    end

    private

    def transform_collection(docs)
      docs.map do |doc|
        puts "Transforming #{doc}"
        next if doc.include?("layers")
        json = JSON.parse(File.read(doc))
        transformer(json).run
      rescue TypeError => e
        puts "Error: #{e.message} Document #{doc}"
        next
      end
    end

    def save_to_destination(docs)
      docs.each do |doc|
        next unless doc
        puts "Saving #{doc["id"]}"
        file = File.new(File.join(destination, "#{doc["id"]}.json"), "w+")
        file << doc.to_json
      rescue => e
        puts "Error: #{e.message} Document #{doc}"
      end
    end

    def transformer(json)
      fix_solr_keys(json)
      GeoCombine::Migrators::V1AardvarkMigrator.new(v1_hash: json)
    rescue NoMethodError => e
      puts "Error: #{e.message} Document #{json}"
    end

    # THIS IS HOPEFULLY TEMPORARY AS THIS PR IS IN FLIGHT - https://github.com/OpenGeoMetadata/GeoCombine/pull/143
    def fix_solr_keys(json)
      json.transform_keys! { |key| (key == "solr_geom") ? "dcat_bbox" : key }
      json.delete("uuid")
    end
  end
end
