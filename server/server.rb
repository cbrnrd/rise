#!/usr/bin/env ruby
require 'webrick'
require 'webrick/https'
require 'openssl'

webrick_options = {
  Port:            443,
  DocumentRoot:    '/root/rise-server-public',
  SSLEnable:       true,
  SSLVerifyClient: OpenSSL::SSL::VERIFY_NONE,
  SSLCertificate:  OpenSSL::X509::Certificate.new(File.read('/etc/letsencrypt/archive/rise.sh/cert3.pem')),
  SSLPrivateKey:   OpenSSL::PKey::RSA.new(File.read('/etc/letsencrypt/archive/rise.sh/privkey3.pem')),
  SSLCertName:     [['US', WEBrick::Utils.getservername]]
}

fork do
  require 'sinatra'
  require 'paint'
  require './create_release'

  set :port, 80
  set :environment, :production
  set :logging, false

  $stderr.puts "\n[Redirect service] Starting redirect microservice with pid: #{Process.pid}"

  get '/api' do
    # TODO
    # After making the full API docs, this will redirect to the https version
    # of that page.
    'You got to the Rise API!'
  end

  put '/api/v1/:uuid/*' do |uuid, path|
    $stderr.puts Paint["API request to #{request.path_info} from #{Paint[request.ip, :blue]}", :red]
    begin
      if request.env['HTTP_AUTHORIZATION'].nil?
        return JSON.pretty_generate({'code' => 401, 'message' => 'Unauthorized'})
      end
      CreateRelease.run(directory: params[:dir], uuid: uuid, path: path, req: request, key: request.env['HTTP_AUTHORIZATION'])
    rescue StandardError => e
      return JSON.pretty_generate({'code' => 500, 'message' => e.message})
    end
  end
end

# Show a cool error page instead of a boring one
module WEBrick
  class HTTPResponse
    def create_error_page
      self.body = File.read('/root/rise-server-public/templates/error.html')
      self.body.gsub!('404', self.status.to_s)
    end
  end
end

server = WEBrick::HTTPServer.new(webrick_options)

# Add login path
server.mount_proc '/login' do |_, res|
  res.body = File.read('/root/rise-server-public/templates/login.html')
end

server.start
