require "geo_combine/migrators/v1_aardvark_migrator"

module SdrCli
  class Transformer
    def initialize(directory:)
      @directory = directory
    end

    def transform_collection
      docs = Dir["#{@directory}/**/*.json"]
      docs.map do |doc|
        json = JSON.parse(File.read(json_file))
        transformer(json).run
      end
    end

    private

    def transformer(json)
      GeoCombine::Migrators::V1AardvarkMigrator.new(v1_hash: json)
    end
  end
end
