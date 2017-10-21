require 'rex/text'
require 'uri'
require 'json'
require 'http'

module Rise
  #
  # Handles all communication with the rise upload server
  #
  module Transport
    # Handles uploading files
    class Uploader
      attr_reader :folder_path, :total_files, :include_folder
      attr_reader :uuid, :current_file, :total_files_size
      attr_accessor :files

      def initialize(folder_path, include_folder = true)
        @folder_path      = folder_path
        @files            = Dir.glob("#{File.absolute_path(folder_path)}/**/*")
        @total_files      = @files.length
        @total_files_size = calculate_files_size
        @include_folder   = include_folder
        @uuid             = "#{File.basename(File.absolute_path(folder_path))}-#{Rex::Text.rand_text_alphanumeric(8)}" # Structure: foldername-8RNDLTRS
      end

      #
      # Uploads the files from +folder_path+ to the upload server
      # @return String the final URL of the uploaded contents
      #
      def upload!(*)
        upload_uri_base = "http://rise.sh:8080/api/v1/#{@uuid}"
        access_uri = "https://rise.sh/#{@uuid}"
        uri = ''

        # This sorts the files by (file path) length.
        # It is supposed to make the server make the first layer of files
        # before the rest of the layers.
        ordered_files = files.sort_by(&:length)
        ordered_files.each do |f|
          isdir = File.directory?(f)
          final_path = File.absolute_path(f).gsub(
            File.expand_path(folder_path), '')
          uri = URI.parse("#{upload_uri_base}/#{final_path}?dir=#{isdir}")
          begin
            HTTP.put(uri.to_s, body: File.read(f))
          rescue Errno::EISDIR
            HTTP.put(uri.to_s, body: '')
            next
          end
        end
        access_uri
      end

      protected

      def calculate_files_size
        @files.inject(0){|sum, file| sum + File.size(file)}
      end
    end
  end
end
