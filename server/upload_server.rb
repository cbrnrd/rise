#!/usr/bin/env ruby
# Sinatra requirements
require 'paint'
require 'sinatra'
require 'sinatra/base'
require 'thin'

# Other useful stuff
require 'fileutils'

# Set sinatra settings here
set :ssl_certificate, '/etc/letsencrypt/archive/rise.sh-0001/fullchain1.pem'
set :ssl_key, '/etc/letsencrypt/archive/rise.sh-0001/privkey1.pem'
set :environment, :production
set :server, 'thin'
set :port, 8080
set :show_exceptions, true if development?

PUBLIC_FOLDER = File.join(Dir.home, 'rise-server-public').freeze

FileUtils.mkdir(PUBLIC_FOLDER) if !File.directory?(PUBLIC_FOLDER)

put '/api/v1/:uuid/*' do |uuid, path|
  isdir = params[:dir]
  if File.directory?(File.join(PUBLIC_FOLDER, uuid))
    if isdir == "true"
      FileUtils.mkdir(File.join(PUBLIC_FOLDER, uuid, path))
      return
    end
    File.open(File.join(PUBLIC_FOLDER, uuid, path), 'w+') do |f|
      request_body = request.body.read
      f.puts(request_body)
    end
  else
    FileUtils.mkdir(File.join(PUBLIC_FOLDER, uuid))
    puts Paint["[#{Time.now}] Creating initial folder with uuid: #{uuid}", :blue]
    if isdir == "true"
      FileUtils.mkdir(File.join(PUBLIC_FOLDER, uuid, path))
      return
    end
    File.open(File.join(PUBLIC_FOLDER, uuid, path), 'w+') do |f|
      request_body = request.body.read
      f.puts(request_body)
    end
  end
end
