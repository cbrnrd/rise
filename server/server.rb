#!/usr/bin/env ruby
# Sinatra requirements
require 'sinatra'
#require 'thin'
require 'sinatra/namespace'

# Other useful stuff
require 'fileutils'

set :server, "thin"
set :environment, :production
set :port, 8080
set :root, File.join(Dir.home, 'rise-server')

namespace '/api/v1' do

  put '/:uuid/:path' do |uuid, path|
    if File.directory?(File.join(Dir.home, 'rise-server', uuid))
      File.open(File.join(Dir.home, 'rise-server', uuid, path), 'w+') do |f|
        request_body = request.body.read
        f.puts(request_body) if !request_body.nil?
        FileUtils.mkdir(File.join(Dir.home, 'rise-server', uuid, path)) if request_body.nil?
      end
    else
      FileUtils.mkdir(File.join(Dir.home, 'rise-server', uuid))
      File.open(File.join(Dir.home, 'rise-server', uuid, path), 'w+') do |f|
        request_body = request.body.read
        f.puts(request_body) if !request_body.nil?
        FileUtils.mkdir(File.join(Dir.home, 'rise-server', uuid, path)) if request_body.nil?
      end
    end
  end
end

get '/:uuid/:file/?' do |uuid, file|
  begin
    File.read(File.join(Dir.home, 'rise-server', uuid, file))
  rescue Errno::ENOENT
    status 404
  end
end

get '/:uuid/?' do |uuid|
  Dir.entries(File.join(Dir.home, 'rise-server', uuid)).map{|e| "<a href src=\"#{e}\">#{e}</a>\n"}
end
