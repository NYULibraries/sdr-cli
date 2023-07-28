require "spec_helper"

RSpec.describe SdrCli::Fetcher do
  let(:harvester) { instance_double(GeoCombine::Harvester) }
  before do
    allow(GeoCombine::Harvester).to receive(:harvester).and_return(harvester)
  end
  describe '#clone' do
    context 'when the repo is not specified' do
      it "should clone all the OGM repos" do
        expect(harvester).to receive(:clone_all)
        described_class.new(ogm_path: "spec/fixtures/ogm", schema_version: "1.0").clone
      end
    end
  end
  it "should pull the GBL data from the OGM repos" do

  end
  it "should fetch the data from the FDA"
  it "should fetch the data from the proprietary/restricted areas"
  it "should have configurations for the schema types for records (XML, GBL 1.0, OGM Aardvark)"
end
