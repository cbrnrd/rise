require 'sinatra'

set :port, 80
set :environment, :production

get '*' do
  redirect('https://rise.sh')
end

