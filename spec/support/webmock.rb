require "webmock/rspec"

stub_request(:get, "https://api.github.com/orgs/opengeometadata/repos").to_return(status: 200, headers: {})
stub_request(:get, Regexp.new("https://github.com/OpenGeoMetadata")).to_return(status: 200, headers: {})
