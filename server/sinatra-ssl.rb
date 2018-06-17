require 'webrick/ssl'
require 'openssl'
require 'webrick'


module Sinatra
  class Application
    def self.run!

      server_options = {
        :Host => bind,
        :Port => port,
        :SSLEnable => true,
        :SSLVerifyClient => OpenSSL::SSL::VERIFY_NONE,
        :SSLCertificate =>   OpenSSL::X509::Certificate.new(File.read('/etc/letsencrypt/archive/rise.sh/cert1.pem')),
        :SSLPrivateKey =>   OpenSSL::PKey::RSA.new(File.read('/etc/letsencrypt/archive/rise.sh/privkey1.pem')),
      }

      Rack::Handler::WEBrick.run self, server_options do |server|
        [:INT, :TERM].each { |sig| trap(sig) { server.stop } }
        server.threaded = settings.threaded if server.respond_to? :threaded=
        set :running, true
      end
    end
  end
end

