#!/usr/bin/env ruby
require 'sinatra'
require 'json'

#Thread.new do
#  require 'sinatra'

#  set :port, 80
#  set :environment, :production
#  set :logging, false

#  puts "\n[Redirect service] Starting redirect microservice with pid: #{Process.pid}"

#  get '*' do |path|
#    redirect("https://rise.sh#{path}")
#  end
#end

#set :environment, :production
#set :port, 443
#set :public_folder, '/root/rise-server-public'

class Application < Sinatra::Base

  configure do
    set :environment, :production
    set :port, 443
    set :bind, '0.0.0.0'
    set :public_folder, '/root/rise-server-public'
  end

  get '/' do
    File.read(File.join(settings.public_folder, 'index.html'))
  end

  get '/*' do |path|
    begin
      File.read(File.join(settings.public_folder, path))
    rescue Errno::ENOENT
      status 404
    end
  end

  error 400..510 do
    puts request
    puts JSON.pretty_generate(request.env)
    File.read(File.join(settings.public_folder, 'templates', 'error.html')).gsub('404', request.env.code)
  end

  def self.run!
    super do |s|
      s.ssl = true
      s.ssl_options = {
	:cert_chain_file => '/etc/letsencrypt/archive/rise.sh/cert1.pem',
	:private_key_file => '/etc/letsencrypt/archive/rise.sh/privkey1.pem',
	:verify_peer => false
      }
    end
  end
end

Application.run!
