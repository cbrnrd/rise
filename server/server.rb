#!/usr/bin/env ruby
require 'webrick'
require 'webrick/https'
require 'openssl'

#CERT_PATH = File.join(Dir.home, 'certs')

webrick_options = {
  :Port             => 443,
  :DocumentRoot     => "/root/rise-server",
  :SSLEnable        => true,
  :SSLVerifyClient  => OpenSSL::SSL::VERIFY_NONE,
  :SSLCertificate   => OpenSSL::X509::Certificate.new(File.read('/etc/letsencrypt/archive/rise.sh/cert1.pem')),
  :SSLPrivateKey    => OpenSSL::PKey::RSA.new(File.read('/etc/letsencrypt/archive/rise.sh/privkey1.pem')),
  :SSLCertName      => [[ 'US', WEBrick::Utils::getservername ]]
}

WEBrick::HTTPServer.new(webrick_options).start
