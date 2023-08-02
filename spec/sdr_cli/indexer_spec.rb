require "spec_helper"
require "solr_wrapper"

RSpec.describe SdrCli::Indexer, :indexer do

  describe "#indexer" do
    let(:indexer) { described_class.new(solr_url: ENV['SOLR_URL']) }
    let(:docs) do
      Dir['spec/fixtures/ogm/edu.umn/metadata-aardvark/Datasets/05d-03/*.json'].each_with_object([]) do |json_file, memo|
        memo << JSON.parse(File.read(json_file))
      end
    end
    it "should create a new record from OGM Aardvark into the Solr index" do
      expect(indexer.index(docs)).to eq docs.length
    end
    it "should update an existing record from OGM Aardvark into the Solr index" do
      indexer.index(docs)
      doc = docs.first
      pp doc

      doc['dct_alternative_sm'] = 'Jawns on Jawns'
      expect(indexer.index([doc])).to eq 1
    end
  end
  it "should create a new Solr index from all records"
  it "should replace a Solr index from all records"
end
