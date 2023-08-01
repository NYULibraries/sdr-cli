# frozen_string_literal: true

source "https://rubygems.org"

# Specify your gem's dependencies in sdr_cli.gemspec
gemspec

gem "rake", "~> 13.0"
gem "rspec", "~> 3.12"
gem "standard", "~> 1.30"

group :test do
  gem  'dotenv'
  gem 'solr_wrapper'
  gem "webmock", "~> 3.18"
end

gem "geo_combine", github: "mnyrop/geocombine", branch: "bug/net-explicit-require"
