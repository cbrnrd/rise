#!/usr/bin/env ruby
# Sinatra requirements
require 'sinatra'
require 'sinatra/base'
require 'thin'

require './create_release'

# Set sinatra settings here
set :environment, :production
set :server, 'thin'
set :port, 8080
set :show_exceptions, true if development?

put '/api/v1/:uuid/*' do |uuid, path|
  begin
    if request.env['HTTP_AUTHORIZATION'].nil?
      return JSON.pretty_generate({'code' => 401, 'message' => 'Unauthorized'})
    end
    CreateRelease.run(directory: params[:dir], uuid: uuid, path: path, req: request, key: request.env['HTTP_AUTHORIZATION'])
  rescue StandardError => e
    return JSON.pretty_generate({'code' => 500, 'message' => e.message})
  end
end

post '/api/v1/creditcard/?' do
  email = params[:email]
  hash  = params[:hash]
  cc    = params[:number]

  if cc.nil? || email.nil? || hash.nil?
    return JSON.pretty_generate({'code' => 400, 'message' => 'The params email, hash, and number must all be filled in'})
  end

  if hash.nil?
    return JSON.pretty_generate({'code' => 401, 'message' => 'Unauthorized'})
  end

  # Do db stuff here
end
