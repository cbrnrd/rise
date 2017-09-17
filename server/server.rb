#!/usr/bin/env ruby
=begin
require 'socket'
server = TCPServer.new '0.0.0.0', 5753

loop do
  Thread.new(server.accept) do |client|
    puts 'conn'
    puts client.gets
  end
end
=end
require 'sinatra'
require 'thin'  # WEBrick makes too much noise
require 'sinatra/namespace'

set :server, "thin"
set :environment, :production

namespace '/api/v1' do

  def base_url
        @base_url ||= "#{request.env['rack.url_scheme']}://{request.env['HTTP_HOST']}"
  end

  before do
    content_type 'application/json'
  end

  get '/hi' do
    'hi'.to_json
  end

  get '/:file' do |file|
    File.read(file)
  end

end
