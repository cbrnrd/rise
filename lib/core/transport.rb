##
# This file handles all communication to the Upto servers
##
require 'rex/text'
require 'uri'
require 'json'
require 'net/http'
module Rise
  module Transport

    # Handles uploading files
    class Uploader

      attr_reader :folder_path, :total_files, :include_folder, :uuid, :current_file
      attr_accessor :files

      def initialize(folder_path, include_folder=true)
        @folder_path    = folder_path
        @files          = Dir.glob("#{File.absolute_path(folder_path)}/**/*")
        @total_files    = @files.length
        @include_folder = include_folder
        @uuid           = "#{File.basename(File.absolute_path(folder_path))}-#{Rex::Text::rand_text_alphanumeric(8)}"  # Structure: foldername-8RNDLTRS
      end

      def upload!(*)
        upload_uri_base = "https://rise.sh:8080/api/v1/#{@uuid}"
        access_uri = "https://rise.sh/#{@uuid}"
        uri = ''

        # This sorts the files by (file path) length.
        # It is supposed to make the server make the first layer of files
        # before the rest of the layers.
        ordered_files = files.sort_by(&:length)
        
        ordered_files.each do |f|
          isdir = File.directory?(f)
          final_path = File.absolute_path(f).gsub(File.expand_path(folder_path), '')
          http = Net::HTTP.new(upload_uri_base, 8080)
          begin
            http.send_request('PUT', "#{final_path}?dir=#{isdir}", File.read(f))
          rescue Errno::EISDIR
            http.send_request('PUT', "#{final_path}?dir=#{isdir}", '')
            next
          end
        end
        return access_uri
      end

    end
  end
end
