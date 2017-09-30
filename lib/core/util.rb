require 'fileutils'

#
# Utility methods
#
module Upto
  module Util

    def self.is_first_run?
      true if File.directory?(File.join(Dir.home, '.upto'))
      false
    end

  end
end
