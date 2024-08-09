# frozen_string_literal: true

require "json"
require "csv"
require "nokogiri"
require "net/http"

module SdrCli
  class Auditor
    attr_reader :directory, :destination

    def initialize(directory:, destination:, check_downloads: false)
      @directory = directory
      @destination = destination
      @check_downloads = check_downloads
    end

    def run
      raise "Cannot find metadata project directory" unless Dir.exist?(@directory)
      raise "Cannot find destination directory" unless Dir.exist?(@destination)

      csv_path = "#{@destination}/aardvark.csv"

      public_wfs_layers = wfs_layer_names("https://maps-public.geo.nyu.edu/geoserver/sdr/wfs").map do |name|
        name.split(":")[1]
      end.sort!

      restricted_wfs_layers = wfs_layer_names("https://maps-restricted.geo.nyu.edu/geoserver/sdr/wfs").map do |name|
        name.split(":")[1]
      end.sort!

      public_wms_layers = wms_layer_names("https://maps-public.geo.nyu.edu/geoserver/sdr/wms").sort!
      restricted_wms_layers = wms_layer_names("https://maps-restricted.geo.nyu.edu/geoserver/sdr/wms").sort!

      headers = %i[category id access format download_url download_status found_in_wfs found_in_wms title]

      json_files = Dir.glob("#{@directory}/metadata-aardvark/*/*.json")

      CSV.open(csv_path, "w", headers:, write_headers: true) do |csv|
        json_files.each_with_index do |path, index|
          parts = path.split("/")
          category = parts[-2]
          file = parts[-1]

          id = file.split(".").first.tr("-", "_")
          data = JSON.parse(File.read(path))
          references = JSON.parse(data["dct_references_s"])

          wfs_url = references["http://www.opengis.net/def/serviceType/ogc/wfs"]
          wms_url = references["http://www.opengis.net/def/serviceType/ogc/wms"]

          wfs_existence = if wfs_url
            wfs_url.include?("public") ? public_wfs_layers.include?(id) : restricted_wfs_layers.include?(id)
          else
            "N/A"
          end

          wms_existence = if wms_url
            wms_url.include?("public") ? public_wms_layers.include?(id) : restricted_wms_layers.include?(id)
          else
            "N/A"
          end

          download_url = references["http://schema.org/downloadUrl"]

          if download_url
            if @check_downloads
              puts "Checking #{index + 1} of #{json_files.size} - #{download_url}..."
              uri = URI(download_url)
              http = Net::HTTP.new(uri.host, uri.port)
              http.use_ssl = uri.scheme == "https"
              http.verify_mode = OpenSSL::SSL::VERIFY_NONE
              request = Net::HTTP::Head.new(uri)

              begin
                download_status = http.request(request).is_a?(Net::HTTPSuccess) ? "Success" : "Failed"
              rescue => e
                download_status = e.message
              end

              puts download_status
            else
              download_status = "Skipped"
            end
          else
            download_status = "N/A"
          end

          csv << [
            category,
            id,
            data["dct_accessRights_s"],
            data["dct_format_s"],
            download_url,
            download_status,
            wfs_existence,
            wms_existence,
            data["dct_title_s"]
          ]
        end
      end
    end

    def wfs_layer_names(url)
      doc = Nokogiri::XML(Net::HTTP.get(URI("#{url}?service=wfs&version=1.3.0&request=GetCapabilities")))
      doc.remove_namespaces!
      doc.xpath("//FeatureType/Name").map(&:text)
    end

    def wms_layer_names(url)
      doc = Nokogiri::XML(Net::HTTP.get(URI("#{url}?service=wms&version=1.3.0&request=GetCapabilities")))
      doc.remove_namespaces!
      doc.xpath("//Layer/Name").map(&:text)
    end
  end
end
