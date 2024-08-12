require "nokogiri"
require "net/http"

module SdrCli
  class WebMapServiceClient
    def initialize(base_url)
      @base_url = base_url
    end

    def layer_names
      doc = Nokogiri::XML(Net::HTTP.get(URI("#{@base_url}?service=wms&version=1.3.0&request=GetCapabilities")))
      doc.remove_namespaces!
      doc.xpath("//Layer/Name").map(&:text)
    end
  end
end
