# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

require 'standard/rake'

task default: %i[spec standard]

namespace :dev do
  desc 'Test Auditor in development'
  task :auditor do
    require_relative 'lib/sdr_cli'

    SdrCli::Cli.start(%w[audit --directory ../edu.nyu --destination .])
  end
end
