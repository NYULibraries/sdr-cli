require "spec_helper"
require "solr_wrapper"

RSpec.describe SdrCli::Indexer do

  describe "#indexer" do
    let(:indexer) { described_class.new(solr_url: ENV['SOLR_URL']) }
    let(:docs) do
      Dir['spec/fixtures/ogm/edu.umn/metadata-aardvark/Datasets/05d-03/*.json'].each_with_object([]) do |json_file, memo|
        memo << JSON.parse(File.read(json_file))
      end
    end
    let(:gc_indexer) { instance_double(GeoCombine::Indexer, solr: true, index: true) }
    before do
      allow(GeoCombine::Indexer).to receive(:new).and_return(gc_indexer)
    end
    it "should create a new record from OGM Aardvark into the Solr index" do
      indexer.index(docs)
      expect(gc_indexer).to have_received(:index).with(docs, commit_within: 5000)
    end
    it "should update an existing record from OGM Aardvark into the Solr index" do
      doc = docs.first
      doc['dct_alternative_sm'] = 'Jawns on Jawns'
      indexer.index([doc])
      expect(gc_indexer).to have_received(:index).with([doc], commit_within: 5000)
    end
  end
  it "should create a new Solr index from all records"
  it "should replace a Solr index from all records"
end
