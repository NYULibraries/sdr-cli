# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

require "standard/rake"

task default: %i[spec standard]

namespace :dev do
  namespace :auditor do
    desc "Test Auditor in development"
    task :light do
      require_relative "lib/sdr_cli"

      SdrCli::Cli.start(%w[audit --directory ../edu.nyu --destination .])
    end

    desc "Test Auditor in development"
    task :full do
      require_relative "lib/sdr_cli"

      SdrCli::Cli.start(%w[audit --directory ../edu.nyu --destination . --check-downloads])
    end
  end
end
