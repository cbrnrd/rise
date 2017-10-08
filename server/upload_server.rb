#!/usr/bin/env ruby
# Sinatra requirements
require 'sinatra'
require 'sinatra/base'
require 'thin'

# Other useful stuff
require 'fileutils'
require 'paint'

# Set sinatra settings here
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
