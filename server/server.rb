#!/usr/bin/env ruby
require 'webrick'
require 'webrick/https'
require 'openssl'

CERT_PATH = File.join(Dir.home, 'certs')

webrick_options = {
  :Port             => 80,
  :DocumentRoot     => "/root/home/rise-server",
  :SSLEnable        => true,
  :SSLVerifyClient  => OpenSSL::SSL::VERIFY_NONE,
  :SSLCertificate   => OpenSSL::X509::Certificate.new(File.read(File.join(CERT_PATH, 'cert.pem'))),
  :SSLPrivateKey    => OpenSSL::PKey::RSA.new(File.read(File.join(CERT_PATH, 'privkey.pem'))),
  :SSLCertName      => [[ 'US', WEBrick::Utils::getservername ]]
}

WEBrick::HTTPServer.new(webrick_options).start
