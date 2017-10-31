#
# Text and printing utility methods
#
module Rise
  module Text
    def self.vputs(msg='')
      puts msg if ENV['RISE_VERBOSE'] == 'yes'
    end
  end
end
