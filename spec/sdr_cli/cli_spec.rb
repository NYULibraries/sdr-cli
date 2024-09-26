# frozen_string_literal: true

RSpec.describe SdrCli::Cli do
  describe "#message" do
    it "returns a message" do
      expect do
        described_class.new.invoke(:cat, [],
          {message: "I'm running this in RSpec"})
          .to output(a_string_including("I'm running this in RSpec")).to_stdout
      end
    end
  end

  describe "#clone" do
    after do
      # clean up to ensure test is idempotent
      FileUtils.rm_rf("tmp/opengeometadata/edu.umn")
    end
    context "when a repo is specified" do
      it "clones a given repository" do
        described_class.new.invoke(:clone,
          [],
          {repo: "edu.umn",
           data_dir: "tmp/opengeometadata",
           schema_version: "1.0"})
        expect(Dir.exist?("tmp/opengeometadata/edu.umn")).to be true
      end
    end
  end

  describe "#pull" do
    after do
      # clean up to ensure test is idempotent
      FileUtils.rm_rf("tmp/opengeometadata/edu.umn")
    end
    context "when a repo is specified" do
      it "pulls a given repository" do
        described_class.new.invoke(:pull,
          [],
          {repo: "edu.umn",
           data_dir: "tmp/opengeometadata",
           schema_version: "1.0"})
        expect(Dir.exist?("tmp/opengeometadata/edu.umn")).to be true
      end
    end
  end

  describe "#index", type: :solr do
    context "when a directory and Solr URL are specified" do
      it "indexes a given directory" do
        dir = "spec/fixtures/ogm/edu.umn/metadata-aardvark/"
        puts Dir.glob("#{dir}**/*.json")
        response = described_class.new.invoke(:index,
          [],
          {directory: dir,
           solr_url: "http://localhost:8983/solr/sdr-core-test"})
        expect(response).to eq Dir.glob("#{dir}**/*.json").length
      end
    end
  end

  describe "#transform" do
    after do
      # clean up to ensure test is idempotent
      FileUtils.rm_rf("tmp/ogm_aardvark")
    end
    context "when a directory and destination are specified" do
      it "transforms a given directory" do
        entry_count = Dir.entries("spec/fixtures/ogm/edu.umn/metadata-1.0/Datasets/05d-04").length
        described_class.new.invoke(:transform,
          [],
          {directory: "spec/fixtures/ogm/edu.umn/metadata-1.0/Datasets/05d-04",
           destination: FileUtils.mkdir("tmp/ogm_aardvark")})
        expect(Dir.entries("tmp/ogm_aardvark").length).to eq entry_count
      end
    end
  end
end
