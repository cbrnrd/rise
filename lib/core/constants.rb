RISE_DATA_DIR = File.join(Dir.home, '.rise')
DOMAIN        = 'rise.sh'.freeze
AUTH_PORT     = 4567.freeze
UPLOAD_PORT   = 8080.freeze

module Rise
  #
  # Holds constants used throughout the framework
  #
  module Constants
    VERSION = '0.1.8'
    EMAIL   = '0xCB@protonmail.com'
    AUTHORS = ['Carter Brainerd']
    NAME    = 'rise-cli'
  end
end
