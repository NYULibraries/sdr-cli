# frozen_string_literal: true

require "spec_helper"

RSpec.describe SdrCli::WebFeatureServiceClient do
  describe "#layer_names" do
    before do
      allow(Net::HTTP).to receive(:get) {
                            <<~XML
                              <?xml version="1.0" encoding="UTF-8"?>
                              <WFS_Capabilities>
                                <FeatureTypeList>
                                  <FeatureType>
                                    <Name>foo</Name>
                                  </FeatureType>
                                  <FeatureType>
                                    <Name>bar</Name>
                                  </FeatureType>
                                  <FeatureType>
                                    <Name>baz</Name>
                                  </FeatureType>
                                </FeatureTypeList>
                              </WFS_Capabilities>
                            XML
                          }
    end

    it "returns a list of layer names available from the service" do
      wfs_client = SdrCli::WebFeatureServiceClient.new("https://maps-public.geo.nyu.edu/geoserver/sdr/wfs")

      expect(wfs_client.layer_names).to include("foo", "bar", "baz")
    end
  end
end
