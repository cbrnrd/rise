#!/usr/bin/env ruby
require 'webrick'
require 'webrick/https'
require 'openssl'

webrick_options = {
  Port:            443,
  DocumentRoot:    '/root/rise-server-public',
  SSLEnable:       true,
  SSLVerifyClient: OpenSSL::SSL::VERIFY_NONE,
  SSLCertificate:  OpenSSL::X509::Certificate.new(File.read('/etc/letsencrypt/archive/rise.sh/cert1.pem')),
  SSLPrivateKey:   OpenSSL::PKey::RSA.new(File.read('/etc/letsencrypt/archive/rise.sh/privkey1.pem')),
  SSLCertName:     [['US', WEBrick::Utils.getservername]]
}

fork do
  require 'sinatra'

  set :port, 80
  set :environment, :production
  set :logging, false

  puts "\n[Redirect service] Starting redirect microservice with pid: #{Process.pid}"

  get '*' do |path|
    redirect("https://rise.sh#{path}")
  end
end

module WEBrick
  class HTTPResponse
    def create_error_page
      self.body = File.read('/root/rise-server-public/templates/error.html')
      self.body.gsub!('404', self.status.to_s)
    end
  end
end

WEBrick::HTTPServer.new(webrick_options).start
