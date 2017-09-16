require 'socket'
server = TCPServer.new '0.0.0.0', 5753

loop do
  Thread.new(server.accept) do |client|
    puts 'conn'
    puts client.gets
  end
end
