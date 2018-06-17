require 'sinatra'
require './sinatra-ssl'

set :port, 443
set :environment, :production

get '/' do
  'hello world'
end
