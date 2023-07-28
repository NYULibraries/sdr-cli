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
end
