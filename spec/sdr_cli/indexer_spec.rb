require "spec_helper"

RSpec.describe SdrCli::Indexer do
  describe "#indexer" do
    let(:indexer) { described_class.new(solr_url: ENV["SOLR_URL"]) }
    let(:dir) { "spec/fixtures/ogm/edu.umn/metadata-aardvark/Datasets/05d-03/*.json" }
    let(:gc_indexer) { instance_double(GeoCombine::Indexer, solr: true, index: true) }

    before do
      allow(GeoCombine::Indexer).to receive(:new).and_return(gc_indexer)
    end
    it "should create a new record from OGM Aardvark into the Solr index" do
      indexer.index(dir)
      expect(gc_indexer).to have_received(:index).with(kind_of(Array))
    end
  end
end
