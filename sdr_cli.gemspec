# frozen_string_literal: true

require_relative "lib/sdr_cli/version"

Gem::Specification.new do |spec|
  spec.name = "sdr_cli"
  spec.version = SdrCli::VERSION
  spec.authors = ["Michael Cain"]
  spec.email = ["mmc469@nyu.edu"]

  spec.summary = "A helping hand to NYU's GeoBlacklight instance."
  spec.description = "Records don't index themselves"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2.2"

  spec.metadata["source_code_uri"] = "https://github.com/NYULibraries/sdr-cli"
  spec.metadata["changelog_uri"] = "https://github.com/NYULibraries/sdr-cli/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor Gemfile])
    end
  end
  spec.bindir = "bin"
  spec.executables = ["sdr-cli"]
  spec.require_paths = ["lib"]

  spec.add_dependency "dotenv", "~> 2.7"
  spec.add_dependency "faraday", "~> 2.10.1"
  spec.add_dependency "thor", "~> 1.2.2"
  # spec.add_dependency "geo_combine", "~> 0.8.0"
  spec.add_development_dependency "solr_wrapper", "~> 4.0.2"
  spec.add_development_dependency "pry", "~> 0.14.2"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
