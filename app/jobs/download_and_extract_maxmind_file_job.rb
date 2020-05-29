require "net/http"
require "fileutils"
require "zlib"
require "rubygems/package"

class DownloadAndExtractMaxmindFileJob < ApplicationJob
  queue_as :low
  sidekiq_options retry: 0

  MAXMIND_URI = URI("https://download.maxmind.com/app/geoip_download?edition_id=GeoLite2-City&license_key=#{ENV["MAXMIND_LICENSE_KEY"]}&suffix=tar.gz")
  MAXMIND_DIR = Rails.root.join("tmp/maxmind")
  MAXMIND_PATH = MAXMIND_DIR.join("GeoLite2-City.tar.gz")
  MAXMIND_LEGACY_DIR = Rails.root.join("db/maxmind")
  MAXMIND_LEGACY_PATH = MAXMIND_LEGACY_DIR.join("GeoLite2-City.tar.gz")

  def perform
    ScoutApm::Transaction.ignore! if rand > (ENV["SCOUT_SAMPLE_RATE"] || 1).to_f
    FileUtils.mkdir_p MAXMIND_DIR
    # If the file was already downloaded today, do not download it again.
    return if File.mtime(MAXMIND_PATH).utc.today?
    download
    extract
  rescue => e
    logger.error "Error downloading and extracting maxmind file! #{e.message}"
  end

  def download
    FileUtils.rm_f MAXMIND_PATH

    File.open MAXMIND_PATH, "wb" do |file|
      Net::HTTP.start(MAXMIND_URI.host) do |http|
        http.open_timeout = 1
        http.read_timeout = 1
        http.request_get(MAXMIND_URI) do |response|
          throw :abort if response.body.empty?
          file.write response.body
        end
      end
    rescue => e
      FileUtils.rm_f MAXMIND_PATH
      FileUtils.cp MAXMIND_LEGACY_PATH, MAXMIND_PATH
      logger.error "Error downloading maxmind file! #{e.message}"
    end
  end

  def extract
    untar unzip
  end

  private

  def unzip
    unzipped_path = MAXMIND_PATH.sub(/\.gz\z/, "")
    File.open unzipped_path, "wb" do |unzipped_file|
      Zlib::GzipReader.open MAXMIND_PATH do |zipped_file|
        zipped_file.each_line { |line| unzipped_file.write line }
      end
    end
    unzipped_path
  end

  def untar(tarred_path)
    Gem::Package::TarReader.new File.open(tarred_path) do |tar|
      tar.each do |tarfile|
        destination = MAXMIND_DIR.join(tarfile.full_name)

        if tarfile.directory?
          FileUtils.mkdir_p destination
        else
          FileUtils.mkdir_p File.dirname(destination)
          File.open destination, "wb" do |f|
            f.print tarfile.read
          end
        end
      end
    end
    # FileUtils.rm_rf tarred_path
  end
end
