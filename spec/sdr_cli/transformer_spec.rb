require "spec_helper"

RSpec.describe SdrCli::Transformer do
  let(:geo_transformer) { instance_double(GeoCombine::Migrators::V1AardvarkMigrator, run: true) }
  let!(:path) { "spec/fixtures/ogm/edu.umn/metadata-1.0/Web services/05d-07" }
  let(:transformer) { described_class.new(directory: path) }

  before { allow(transformer).to receive(:transformer).and_return(geo_transformer) }

  it "should transform the data from GBL 1.0 to OGM Aardvark" do
    transformer.transform_collection
    expect(geo_transformer).to have_received(:run).exactly(Dir["#{path}/**/*.json"].length).times
  end
end
