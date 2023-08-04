require "geo_combine/migrators/v1_aardvark_migrator"

module SdrCli
  class Transformer
    attr_reader :directory, :destination

    def initialize(directory:, destination: )
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
        json = JSON.parse(File.read(doc))
        transformer(json).run
      end
    end

    def save_to_destination(docs)
      docs.each do |doc|
        json = JSON.parse(doc)
        File.open(File.join(destination, json['id']), "w+") do |f|
          f.write(doc)
        end
      end
    end


    def transformer(json)
      GeoCombine::Migrators::V1AardvarkMigrator.new(v1_hash: json)
    end
  end
end
