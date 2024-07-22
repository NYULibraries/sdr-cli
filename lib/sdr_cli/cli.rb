require "thor"

module SdrCli
  class Cli < Thor
    desc "clone", "clones all OGM repositories or pass --repo to clone a specific repository"
    long_desc <<-MSG
      a command to clone all OGM repositories (via GeoCombine).  If you want to clone a specific repository, pass the --repo option.
    MSG
    option :repo
    option :data_dir
    option :schema_version
    def clone
      ogm_path = options["data_dir"] || ENV.fetch("OGM_PATH", "tmp/opengeometadata")
      schema_version = options["schema_version"] || ENV.fetch("SCHEMA_VERSION", "1.0")

      SdrCli::Fetcher.new(ogm_path:, schema_version:, repo: options["repo"]).clone
    end

    desc "pull", "updates all OGM repositories or pass --repo to update a specific repository"
    long_desc <<-MSG
      a command to clone all OGM repositories (via GeoCombine).  If you want to clone a specific repository, pass the --repo option.
    MSG
    option :repo
    option :data_dir
    option :schema_version
    def pull
      ogm_path = options["data_dir"] || ENV.fetch("OGM_PATH", "tmp/opengeometadata")
      schema_version = options["schema_version"] || ENV.fetch("SCHEMA_VERSION", "1.0")

      SdrCli::Fetcher.new(ogm_path:, schema_version:, repo: options["repo"]).pull
    end

    desc "index", "index a directory of geospatial documents to Solr"
    long_desc <<-MSG
      a command to index a directory of geospatial documents to Solr.
      Pass the --directory option to specify the directory containing the geospatial documents.
      Pass the --solr_url option to specify the Solr URL.
    MSG

    option :directory
    option :solr_url
    def index
      directory = options["directory"]
      raise ArgumentError, "You must specify a directory" unless directory
      solr_url = options["solr_url"]
      raise ArgumentError, "You must specify a Solr URL" unless solr_url
      SdrCli::Indexer.new(solr_url: solr_url).index(directory)
    end

    desc "transform", "transforms a collection of GeoBlacklight 1.0 documents to OGM Aardvark"
    long_desc <<-MSG
      a command to transform a collection of GeoBlacklight 1.0 documents to OGM Aardvark.  
      Pass the --directory option to specify the directory containing the GeoBlacklight 1.0 documents.  
      Pass the --destination option to specify the directory where the transformed documents will be saved.
    MSG

    option :directory
    option :destination
    def transform
      directory = options["directory"]
      destination = options["destination"]

      raise ArgumentError, "You must specify a directory containing GeoBlacklight 1.0 documents" unless directory
      raise ArgumentError, "You must specify a destination directory" unless destination

      SdrCli::Transformer.new(directory: directory, destination: destination).run
    end

    desc "audit", "Compares the metadata repo with what's available in NYU GeoServer instances"
    long_desc <<-MSG
      A command to compare the metadata repo with what's available in NYU GeoServer instances.
      Pass the --directory option to specific the directory containing the NYU Metadata repository.
      Pass the --destination option to specify the directory where the audit report CSV will be saved.
    MSG

    option :directory
    option :destination
    def audit
      directory = options["directory"]
      destination = options["destination"]

      raise ArgumentError, "You must specify the metadata project directory" unless directory
      raise ArgumentError, "You must specify a destination directory" unless destination

      SdrCli::Auditor.new(directory: directory, destination: destination).run
    end
  end
end
