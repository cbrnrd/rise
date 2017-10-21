RISE_DATA_DIR = File.join(Dir.home, '.rise')
DOMAIN        = 'rise.sh'.freeze
AUTH_PORT     = 4567
UPLOAD_PORT   = 8080

module Rise
  #
  # Holds constants used throughout the framework
  #
  module Constants
    VERSION  = '0.2.0'.freeze
    EMAIL    = '0xCB@protonmail.com'.freeze
    AUTHORS  = ['Carter Brainerd']
    NAME     = 'rise-cli'.freeze
    RISE_DIR = File.join(File.dirname(__FILE__), '..', '..')
  end
end
