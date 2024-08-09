module SdrCli
  class AardvarkFile
    def initialize(path)
      @data = JSON.parse(File.read(path))
      @references = JSON.parse(@data["dct_references_s"])
    end

    def wfs_url
      @references["http://www.opengis.net/def/serviceType/ogc/wfs"]
    end

    def wms_url
      @references["http://www.opengis.net/def/serviceType/ogc/wms"]
    end

    def download_url
      @references["http://schema.org/downloadUrl"]
    end

    def access_rights
      @data["dct_accessRights_s"]
    end

    def format
      @data["dct_format_s"]
    end

    def title
      @data["dct_title_s"]
    end

    def wxs_identifier
      @data["gbl_wxsIdentifier_s"]
    end
  end
end
