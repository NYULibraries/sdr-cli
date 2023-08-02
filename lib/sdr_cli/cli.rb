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
      ogm_path = options[:data_dir] || ENV.fetch("OGM_PATH", "tmp/opengeometadata")
      schema_version = options[:schema_version] || ENV.fetch("SCHEMA_VERSION", "1.0")

      SdrCli::Fetcher.new(ogm_path:, schema_version:, repo: options[:repo]).clone
    end

    desc "pull", "updates all OGM repositories or pass --repo to update a specific repository"
    long_desc <<-MSG
      a command to clone all OGM repositories (via GeoCombine).  If you want to clone a specific repository, pass the --repo option.
    MSG
    option :repo
    option :data_dir
    option :schema_version
    def pull
      ogm_path = options[:data_dir] || ENV.fetch("OGM_PATH", "tmp/opengeometadata")
      schema_version = options[:schema_version] || ENV.fetch("SCHEMA_VERSION", "1.0")

      SdrCli::Fetcher.new(ogm_path:, schema_version:, repo: options[:repo]).pull
    end
  end
end
