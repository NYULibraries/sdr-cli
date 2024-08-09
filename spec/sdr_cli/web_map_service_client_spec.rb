# frozen_string_literal: true

require "spec_helper"

RSpec.describe SdrCli::WebMapServiceClient do
  describe "#layer_names" do
    before do
      allow(Net::HTTP).to receive(:get) {
                            <<~XML
                              <?xml version="1.0" encoding="UTF-8"?>
                              <WMS_Capabilities>
                                <Capability>
                                  <Layer>
                                    <Layer>
                                      <Name>foo</Name>
                                    </Layer>
                                    <Layer>
                                      <Name>bar</Name>
                                    </Layer>
                                    <Layer>
                                      <Name>baz</Name>
                                    </Layer>
                                  </Layer>
                                </Capability>
                              </WMS_Capabilities>                              
                            XML
                          }
    end

    it "returns a list of layer names available from the service" do
      wms_client = SdrCli::WebMapServiceClient.new("https://maps-public.geo.nyu.edu/geoserver/sdr/wms")

      expect(wms_client.layer_names).to include("foo", "bar", "baz")
    end
  end
end
