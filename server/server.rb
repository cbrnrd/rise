#!/usr/bin/env ruby
# Sinatra requirements
require 'sinatra'
require 'thin'
require 'sinatra/namespace'

# Other useful stuff
require 'fileutils'

set :server, "thin"
set :environment, :production
set :port, 8080

namespace '/api/v1' do

  put '/:uuid/:path' do |uuid, path|
    if File.directory?(File.join(Dir.home, 'upto-server', uuid))
      File.open(File.join(Dir.home, 'upto-server', uuid, path), 'w+') do |f|
        request_body = request.body.read
        f.puts(request_body) if !request_body.nil?
        FileUtils.mkdir(File.join(Dir.home, 'upto-server', uuid, path)) if request_body.nil?
      end
    else
      FileUtils.mkdir(File.join(Dir.home, 'upto-server', uuid))
      File.open(File.join(Dir.home, 'upto-server', uuid, path), 'w+') do |f|
        request_body = request.body.read
        f.puts(request_body) if !request_body.nil?
        FileUtils.mkdir(File.join(Dir.home, 'upto-server', uuid, path)) if request_body.nil?
      end
    end
  end
end
