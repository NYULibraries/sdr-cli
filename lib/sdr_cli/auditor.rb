# frozen_string_literal: true

require "json"
require "csv"
require "nokogiri"
require "net/http"

module SdrCli
  class Auditor
    attr_reader :directory, :destination

    HEADERS = %i[category file access format download_url download_status wxs_identifier wfs_status wms_status title]

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

      public_wfs_layers = SdrCli::WebFeatureServiceClient.new("https://maps-public.geo.nyu.edu/geoserver/ows").layer_names
      restricted_wfs_layers = SdrCli::WebFeatureServiceClient.new("https://maps-restricted.geo.nyu.edu/geoserver/ows").layer_names

      public_wms_layers = SdrCli::WebMapServiceClient.new("https://maps-public.geo.nyu.edu/geoserver/ows").layer_names
      restricted_wms_layers = SdrCli::WebMapServiceClient.new("https://maps-restricted.geo.nyu.edu/geoserver/ows").layer_names

      CSV.open(csv_path, "w", headers: HEADERS, write_headers: true) do |csv|
        json_files.each_with_index do |path, index|
          *_, category, file = path.split("/")

          aardvark = SdrCli::AardvarkFile.new(path)

          wfs_status = if aardvark.wfs_url
            available = aardvark.wfs_url.include?("public") ? public_wfs_layers.include?(aardvark.wxs_identifier) : restricted_wfs_layers.include?(aardvark.wxs_identifier)
            available ? "Found" : "Missing"
          else
            "N/A"
          end

          wms_status = if aardvark.wms_url
            available = aardvark.wms_url.include?("public") ? public_wms_layers.include?(aardvark.wxs_identifier) : restricted_wms_layers.include?(aardvark.wxs_identifier)
            available ? "Found" : "Missing"
          else
            "N/A"
          end

          download_status = if aardvark.download_url
            if @check_downloads
              puts "Checking #{index + 1} of #{json_files.size} - #{aardvark.download_url}..."
              get_download_status(aardvark.download_url)
            else
              "Not Checked"
            end
          else
            "No Download URL"
          end

          csv << [
            category,
            file,
            aardvark.access_rights,
            aardvark.format,
            aardvark.download_url,
            download_status,
            aardvark.wxs_identifier,
            wfs_status,
            wms_status,
            aardvark.title
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
