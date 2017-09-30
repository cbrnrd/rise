##
# This file handles all communication to the Upto servers
##
require 'colorize'
require 'rex/text'
require 'uri'
require 'json'
require 'http'

module Upto
  module Transport

    # Handles uploading files
    class Uploader

      attr_reader :folder_path, :total_files, :include_folder, :uuid
      attr_accessor :files

      def initialize(folder_path, include_folder=true)
          @folder_path    = folder_path
          @files          = Dir.glob("#{File.absolute_path(folder_path)}/**/*")
          @total_files    = @files.length
          @include_folder = include_folder
          @uuid           = "#{File.basename(File.absolute_path(folder_path))}-#{Rex::Text::rand_text_alphanumeric(8)}"  # Structure: foldername-8RNDLTRS
      end

      def upload!(verbose=false)
        uri_base = "http://localhost:8080/api/v1/#{@uuid}"  # XXX: change this when the domain is registered
        uri = ''
        files.each do |f|
          final_path = File.absolute_path(f).gsub(File.expand_path(folder_path), '')
          uri = URI.parse("#{uri_base}/#{final_path}")
          response = HTTP.put(uri.to_s, :body => File.read(f)) unless File.directory?(f)
          response = HTTP.put(uri.to_s, :body => nil) if File.directory?(f)

        end
        return uri_base
      end

    end
  end
end
