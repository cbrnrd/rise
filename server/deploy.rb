# Other useful stuff
require 'fileutils'
require 'paint'

class Deploy
  PUBLIC_FOLDER = File.join(Dir.home, 'rise-server-public').freeze

  FileUtils.mkdir(PUBLIC_FOLDER) if !File.directory?(PUBLIC_FOLDER)

  attr_accessor :directory, :uuid, :path

  class << self
    def create(directory: false, uuid:, path:)
      service = self.new(directory: directory, uuid: uuid, path: path)
      return FileUtils.mkdir(File.join(PUBLIC_FOLDER, uuid, path)) if service.directory
      service.create!
    end
  end

  def init(directory: false, uuid:, path:)
    @directory = directory.to_s === 'true'
    @uuid      = uuid
    @path      = path
    create_base_folder
  end

  def create_base_folder
    unless File.directory?(File.join(PUBLIC_FOLDER, uuid))
      puts Paint["[#{Time.now}] Creating initial folder with uuid: #{uuid}", :blue]
      FileUtils.mkdir(File.join(PUBLIC_FOLDER, uuid))
    end
  end

  def create!
    File.open(File.join(PUBLIC_FOLDER, uuid, path), 'w+') do |f|
      request_body = request.body.read
      f.puts(request_body)
    end
  end
end
