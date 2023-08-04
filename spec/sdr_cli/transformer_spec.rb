require "spec_helper"

RSpec.describe SdrCli::Transformer do
  let(:aardvark_path) { "spec/fixtures/aardvark/0f3c5f91-37dc-4557-9606-9658ae45a4c8.json" }
  let(:aardvark_doc) { JSON.parse(File.read(aardvark_path)) }
  let(:geo_transformer) { instance_double(GeoCombine::Migrators::V1AardvarkMigrator, run: aardvark_doc) }
  let!(:directory) { "spec/fixtures/gbl_1" }
  let(:transformer) { described_class.new(directory: directory, destination: "tmp") }

  before { allow(transformer).to receive(:transformer).and_return(geo_transformer) }

  it "should transform the data from GBL 1.0 to OGM Aardvark" do
    transformer.run
    expect(geo_transformer).to have_received(:run).exactly(Dir["#{directory}/**/*.json"].length).times
  end

  it "should save the transformed data to the destination" do
    transformer.run
    file =  File.join("tmp", "#{aardvark_doc["id"]}.json")
    expect(File.exist?(file)).to be true

    # clean up file to ensure test idempotency
    # FileUtils.remove_file(destination_file)
  end
end
