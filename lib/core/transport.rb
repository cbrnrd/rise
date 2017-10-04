##
# This file handles all communication to the Upto servers
##
require 'colorize'
require 'rex/text'
require 'uri'
require 'json'
require 'http'

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
        uri_base = "http://localhost:8080/api/v1/#{@uuid}"  # XXX: change this when the domain is registered
        uri = ''

        # This sorts the files by (file path) length.
        # It is supposed to make the server make the first layer of files
        # before the rest of the layers.
        ordered_files = files.sort_by(&:length)
        ordered_files.each do |f|
          isdir = File.directory?(f)
          final_path = File.absolute_path(f).gsub(File.expand_path(folder_path), '')
          uri = URI.parse("#{uri_base}/#{final_path}?dir=#{isdir}")
          puts uri
          begin
            HTTP.put(uri.to_s, :body => File.read(f))
          rescue Errno::EISDIR
            HTTP.put(uri.to_s, :body => '')
            next
          end
        end
        return uri_base
      end

    end
  end
end
