#!/usr/bin/env ruby
# Sinatra requirements
require 'paint'
require 'sinatra'
require 'sinatra/base'
require 'thin'

# Other useful stuff
require 'fileutils'

class UploadServer < Sinatra::Base
  # Set sinatra settings here
  set :environment, :production
  set :server, 'thin'
  set :port, 8080
  set :show_exceptions, true if development?

  FileUtils.mkdir(File.join(Dir.home, 'rise-server')) if !File.directory?(File.join(Dir.home, 'rise-server'))

  put '/api/v1/:uuid/*' do |uuid, path|
    isdir = params[:dir]
    if File.directory?(File.join(Dir.home, 'rise-server', uuid))
      if isdir == "true"
        FileUtils.mkdir(File.join(Dir.home, 'rise-server', uuid, path))
        return
      end
      File.open(File.join(Dir.home, 'rise-server', uuid, path), 'w+') do |f|
        request_body = request.body.read
        f.puts(request_body)
      end
    else
      FileUtils.mkdir(File.join(Dir.home, 'rise-server', uuid))
      puts Paint["[#{Time.now}] Creating initial folder with uuid: #{uuid}", :blue]
      if isdir == "true"
        FileUtils.mkdir(File.join(Dir.home, 'rise-server', uuid, path))
        return
      end
      File.open(File.join(Dir.home, 'rise-server', uuid, path), 'w+') do |f|
        request_body = request.body.read
        f.puts(request_body)
      end
    end
  end

  def self.run!
    super do |server|
      server.ssl = true
      server.ssl_options = {
        :cert_chain_file  => File.join(Dir.home, 'certs', 'cert.pem'),
        :private_key_file => File.join(Dir.home, 'certs', 'privkey.pem'),
        :verify_peer      => false
      }
    end
  end
  run! if app_file == $0
end
