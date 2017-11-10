# Other useful stuff
require 'active_support'
require 'fileutils'
require 'paint'

class CreateRelease
  PUBLIC_FOLDER = File.join(Dir.home, 'rise-server-public').freeze

  FileUtils.mkdir(PUBLIC_FOLDER) if !File.directory?(PUBLIC_FOLDER)

  attr_accessor :directory, :uuid, :path, :request, :key

  class << self
    def run(directory: false, uuid:, path:, req:, key:)
      service = self.new(directory: directory, uuid: uuid, path: path, req: req, key: key)
      return FileUtils.mkdir(File.join(PUBLIC_FOLDER, uuid, path)) if service.directory
      service.run
    end
  end

  def initialize(directory: false, uuid:, path:, req:, key:)
    @directory = directory.to_s === 'true'
    @uuid      = uuid
    @path      = path
    @request   = req
    @key       = key
    create_base_folder
  end

  def create_base_folder
    unless File.directory?(File.join(PUBLIC_FOLDER, uuid))
      puts Paint["[#{Time.now}] Creating initial folder with uuid: #{uuid}", :blue]
      FileUtils.mkdir(File.join(PUBLIC_FOLDER, uuid))
    end
  end

  def run
    # Keyfile writing
    File.open(File.join(PUBLIC_FOLDER, uuid, '.keyfile'), 'w') do |f|
      f.print @key
    end unless File.exists?(File.join(PUBLIC_FOLDER, uuid, '.keyfile'))

    # Actual file contents writing
    File.open(File.join(PUBLIC_FOLDER, uuid, path), 'w+') do |f|
      request_body = ActiveSupport::Gzip.decompress(request.body.read)
      f.puts(request_body)
    end
  end
end
