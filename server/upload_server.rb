#!/usr/bin/env ruby
# Sinatra requirements
require 'sinatra'
require 'sinatra/base'
require 'thin'

require 'create_release'

# Set sinatra settings here
set :environment, :production
set :server, 'thin'
set :port, 8080
set :show_exceptions, true if development?

put '/api/v1/:uuid/*' do |uuid, path|
  CreateRelease.run(directory: params[:dir], uuid: uuid, path: path)
end
