# frozen_string_literal: true

require "json"
require "csv"
require "nokogiri"
require "net/http"

module SdrCli
  class Auditor
    attr_reader :directory, :destination

    WFS_REFERENCE_KEY = "http://www.opengis.net/def/serviceType/ogc/wfs"
    WMS_REFERENCE_KEY = "http://www.opengis.net/def/serviceType/ogc/wms"
    DOWNLOAD_REFERENCE_KEY = "http://schema.org/downloadUrl"

    def initialize(directory:, destination:, check_downloads: false)
      @directory = directory
      @destination = destination
      @check_downloads = check_downloads
    end

    def run
      raise "Cannot find metadata project directory" unless Dir.exist?(@directory)
      raise "Cannot find destination directory" unless Dir.exist?(@destination)

      csv_path = "#{@destination}/aardvark.csv"
      json_files = Dir.glob("#{@directory}/metadata-aardvark/*/*.json")
      headers = %i[category id access format download_url download_status found_in_wfs found_in_wms title]

      public_wfs_layers = SdrCli::WebFeatureServiceClient.new("https://maps-public.geo.nyu.edu/geoserver/sdr/wfs").layer_names.map { |name| name.split(":")[1] }.sort!
      restricted_wfs_layers = SdrCli::WebFeatureServiceClient.new("https://maps-restricted.geo.nyu.edu/geoserver/sdr/wfs").layer_names.map { |name| name.split(":")[1] }.sort!

      public_wms_layers = SdrCli::WebMapServiceClient.new("https://maps-public.geo.nyu.edu/geoserver/sdr/wms").layer_names.sort!
      restricted_wms_layers = SdrCli::WebMapServiceClient.new("https://maps-restricted.geo.nyu.edu/geoserver/sdr/wms").layer_names.sort!

      CSV.open(csv_path, "w", headers:, write_headers: true) do |csv|
        json_files.each_with_index do |path, index|
          *_, category, file = path.split("/")

          id = file.split(".").first.tr("-", "_")
          data = JSON.parse(File.read(path))
          references = JSON.parse(data["dct_references_s"])

          wfs_url = references[WFS_REFERENCE_KEY]
          wms_url = references[WMS_REFERENCE_KEY]

          wfs_existence = if wfs_url
            available = wfs_url.include?("public") ? public_wfs_layers.include?(id) : restricted_wfs_layers.include?(id)
            available ? "Found" : "Missing"
          else
            "N/A"
          end

          wms_existence = if wms_url
            available = wms_url.include?("public") ? public_wms_layers.include?(id) : restricted_wms_layers.include?(id)
            available ? "Found" : "Missing"
          else
            "N/A"
          end

          download_url = references[DOWNLOAD_REFERENCE_KEY]

          download_status = if download_url
            if @check_downloads
              puts "Checking #{index + 1} of #{json_files.size} - #{download_url}..."
              get_download_status(download_url)
            else
              "Skipped"
            end
          else
            "N/A"
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

    private

    def get_download_status(download_url)
      uri = URI(download_url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = uri.scheme == "https"
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      request = Net::HTTP::Head.new(uri)

      begin
        http.request(request).is_a?(Net::HTTPSuccess) ? "Success" : "Failed"
      rescue => e
        e.message
      end
    end
  end
end
