require "spec_helper"

RSpec.describe SdrCli::Transformer do
  let(:aardvark_path) { "spec/fixtures/ogm/edu.umn/metadata-aardvark/Datasets/05d-03/0f3c5f91-37dc-4557-9606-9658ae45a4c8.json" }
  let(:aardvark_doc) { File.read(aardvark_path) }
  let(:destination_file) { File.join("spec/fixtures/aardvark", JSON.parse(aardvark_doc)["id"]) }
  let(:geo_transformer) { instance_double(GeoCombine::Migrators::V1AardvarkMigrator, run: aardvark_doc) }
  let!(:directory) { "spec/fixtures/ogm/edu.umn/metadata-1.0/Web services/05d-07" }
  let(:transformer) { described_class.new(directory: directory, destination: "spec/fixtures/aardvark") }

  before { allow(transformer).to receive(:transformer).and_return(geo_transformer) }

  it "should transform the data from GBL 1.0 to OGM Aardvark" do
    transformer.run
    expect(geo_transformer).to have_received(:run).exactly(Dir["#{directory}/**/*.json"].length).times
  end

  it "should save the transformed data to the destination" do
    transformer.run
    expect(File.exist?(destination_file)).to be true

    # clean up file to ensure test idempotency
    FileUtils.remove_file(destination_file)
  end
end
