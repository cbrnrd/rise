#!/usr/bin/env ruby
# Sinatra requirements
require 'sinatra'
require 'sinatra/base'
require 'thin'

require_relative './deploy'

# Set sinatra settings here
set :environment, :production
set :server, 'thin'
set :port, 8080
set :show_exceptions, true if development?

put '/api/v1/:uuid/*' do |uuid, path|
  Deploy.create(directory: params[:dir], uuid: uuid, path: path)
end
