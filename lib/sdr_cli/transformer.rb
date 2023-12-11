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
      fix_solr_doc(json)
      GeoCombine::Migrators::V1AardvarkMigrator.new(v1_hash: json)
    rescue NoMethodError => e
      puts "Error: #{e.message} Document #{json}"
    end

    # THIS IS HOPEFULLY TEMPORARY AS THIS PR IS IN FLIGHT - https://github.com/OpenGeoMetadata/GeoCombine/pull/143
    def fix_solr_doc(json)
      json.transform_keys! do |key|
        case key
        when "solr_geom"
          "locn_geometry"
        when "layer_geom_type_s"
          "gbl_resourceType_sm"
        when "dc_type_s"
          "gbl_resourceClass_sm"
        else
          key
        end
      end
      json.delete("uuid")
      json["gbl_resourceType_sm"] = translate_geom_type_data(json["gbl_resourceType_sm"])
      json["gbl_resourceClass_sm"] = translate_geom_type_class(json["gbl_resourceClass_sm"])
      json["gbl_mdVersion_s"] = "4.0"
    end

    def translate_geom_type_data(geom_type)
      case geom_type
      when "Polygon"
        "Polygon data"
      when "Point"
        "Point data"
      when "Raster"
        "Raster data"
      when "Line"
        "Line data"
      when "Mixed"
        "Multi-spectral data"
      when "Image"
        "Satellite imagery"
      else
        geom_type
      end
    end

    def translate_geom_type_class(geo_class)
      case geo_class
      when "Dataset"
        "Datasets"
      when "Image"
        "Imagery"
      else
        geo_class
      end
    end
  end
end
