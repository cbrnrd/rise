require 'sinatra'
require 'sinatra/reloader'
require 'thin'

set :port, 80
set :environment, :production

configure :production do
  enable :reloader
end

get '/:uuid/*' do |uuid, file|
  if file.nil?
    haml :dir_listing
  end
  File.read(File.join(Dir.home, 'rise-server', uuid, file))
end
