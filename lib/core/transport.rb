require 'rex/text'
require 'uri'
require 'json'
require 'http'
require 'active_support'


module Rise
  #
  # Handles all communication with the rise upload server
  #
  module Transport
    # Handles uploading files
    class Uploader
      attr_reader :folder_path, :total_files, :include_folder
      attr_reader :uuid, :current_file, :total_files_size, :key
      attr_accessor :files

      def initialize(folder_path, key, excluded_files = [], include_folder = true)
        excluded_files.map! do |a|
          File.join(File.absolute_path(folder_path), a)
        end unless excluded_files.nil?
        @folder_path      = folder_path
        @files            = Dir.glob("#{File.absolute_path(folder_path)}/**/*")
        @files           -= excluded_files unless excluded_files.nil?
        @total_files      = @files.length
        @total_files_size = calculate_files_size
        @include_folder   = include_folder
        @uuid             = "#{File.basename(File.absolute_path(folder_path)).gsub('_', '-')}-#{Rex::Text.rand_text_alphanumeric(8)}" # Structure: foldername-8RNDLTRS
        @key              = key
      end

      # This makes a HTTP +PUT+ request on port 8080 to the /api/v1/ endpoint
      # for each file in the selected folder.
      #
      # The body of the request is the contents of the file.
      #
      # The +Authorization+ request header is used for making the .keyfile on the serverside
      # for the future file deletion method.
      # @return String the final URL of the uploaded contents
      #
      def upload!
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
          uri = URI.parse("#{upload_uri_base}/#{final_path.gsub(' ', '')}?dir=#{isdir}")
          begin
            res = HTTP.auth("#{key}").put(uri.to_s, body: ActiveSupport::Gzip.compress(File.read(f)))
            abort(Paint["Upload failed. Got error code #{res.code} with message: #{JSON.parse(res)['message']}", :red]) unless (!res.code.nil? && res.code == 200)
          rescue Errno::EISDIR
            res = HTTP.auth("#{key}").put(uri.to_s, body: '')
            abort(Paint["Upload failed. Got error code #{res.code} with message: #{JSON.parse(res)['message']}", :red]) unless (!res.code.nil? && res.code == 200)
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
