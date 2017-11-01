require 'paint'
#
# Text and printing utility methods
#
module Rise
  module Text

    TASKS_HELP =
    %Q{    init                             Reinitialize your password hash. (You will lose you old hash FOREVER)
    update                           Updates the current rise-cli installation (aliased by -u)

Examples:
    #{Paint['$ rise init -v', '#2ecc71']}                    Reinitializes your password with verbose output
    #{Paint['$ rise -d ../my-project -o', '#2ecc71']}        Will upload all files in `../my-project` and open it in a browser
    }

    #
    # Prints +msg+ if the +RISE_VERBOSE+ environment variable is true (set with --verbose)
    #
    def self.vputs(msg='')
      puts msg if ENV['RISE_VERBOSE'] == 'yes'
    end
  end
end
