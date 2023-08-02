require "spec_helper"

RSpec.describe SdrCli::Fetcher do
  let(:harvester) do
    instance_double(GeoCombine::Harvester,
                    clone: true,
                    clone_all: true,
                    pull: true,
                    pull_all: true)
  end

  describe "#clone" do
    context "when the repo is not specified" do
      it "should clone all the OGM repos" do
        fetcher = described_class.new(ogm_path: "spec/fixtures/ogm")
        allow(fetcher).to receive(:harvester).and_return(harvester)

        fetcher.clone

        expect(harvester).to have_received(:clone_all)
      end
    end
    context "when the repo is specified" do
      it "should clone the specified repo" do
        fetcher = described_class.new(ogm_path: "spec/fixtures/ogm", repo: "my_repo")
        allow(fetcher).to receive(:harvester).and_return(harvester)

        fetcher.clone

        expect(harvester).to have_received(:clone).with("my_repo")
      end
    end
    context 'when the schema is declared' do
      it "should have configurations for the schema type specified" do
        fetcher = described_class.new(ogm_path: "spec/fixtures/ogm", schema_version: "aardvark")
        harvester_class = class_double(GeoCombine::Harvester).as_stubbed_const
        allow(harvester_class).to receive(:new)

        fetcher.send(:harvester)

        expect(harvester_class).to have_received(:new).with(ogm_path: "spec/fixtures/ogm",
          schema_version: "aardvark")
      end
    end
  end
  describe "#pull" do
    context "when the repo is not specified" do
      it "should pull all the OGM repos" do
        fetcher = described_class.new(ogm_path: "spec/fixtures/ogm")
        allow(fetcher).to receive(:harvester).and_return(harvester)

        fetcher.pull

        expect(harvester).to have_received(:pull_all)
      end
    end
    context "when the repo is specified" do
      it "should pull the specified repo" do
        fetcher = described_class.new(ogm_path: "spec/fixtures/ogm", repo: "my_repo")
        allow(fetcher).to receive(:harvester).and_return(harvester)

        fetcher.pull

        expect(harvester).to have_received(:pull).with("my_repo")
      end
    end
    context 'when the schema is declared' do
      it "should have configurations for the schema type specified" do
        fetcher = described_class.new(ogm_path: "spec/fixtures/ogm", schema_version: "aardvark")
        harvester_class = class_double(GeoCombine::Harvester).as_stubbed_const
        allow(harvester_class).to receive(:new)

        fetcher.send(:harvester)

        expect(harvester_class).to have_received(:new).with(ogm_path: "spec/fixtures/ogm",
          schema_version: "aardvark")
      end
    end
  end
  it "should fetch the data from the FDA"
  it "should fetch the data from the proprietary/restricted areas"
end
