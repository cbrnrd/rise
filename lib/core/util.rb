require 'fileutils'
require 'paint'
require 'json'
require 'http'
require 'digest'
require 'io/console'
require 'tempfile'
require 'whirly'
require_relative 'constants'

module Rise
  #
  # Utility methods
  #
  module Util

    #
    # Checks if rise is being run for the first time
    #
    def self.is_first_run?
      !File.directory?(File.join(Dir.home, '.rise'))
    end

    #
    # Check for a new version of the gem
    #
    def self.check_for_update!
      begin
        output = ''
        temp = Tempfile.new('rise-updater-output')
        path = temp.path
        system("gem outdated > #{path}")
        output << temp.read
        if output.include? 'rise-cli'
          Whirly.start(spinner: 'line', status: Paint['New version available, updating...', 'blue']) do
            system("gem uninstall rise-cli -v #{Rise::Constants::VERSION} > /dev/null")
            system("gem install rise-cli > /dev/null")
            puts Paint["Update complete, just run #{Paint['`rise`', '#3498db']} to deploy"]
          end
        end
      rescue Exception => e
        puts "Unable to check for updates. Error: #{Paint[e.message, 'red']}"
        exit 1
      ensure
        temp.close
        temp.unlink
      end
    end
    #
    # Creates all of the necessary files and login information
    #
    def self.setup
      puts Paint['Detected first time setup, creating necessary files...', :blue]
      FileUtils.mkdir(RISE_DATA_DIR)
      FileUtils.mkdir(File.join(RISE_DATA_DIR, 'auth'))

      #TODO Reimplement when the backend server actually works
      # Get the input from the user
      #print Paint['1. Log in\n2. Sign up\n  > ', :bold]
      #while (choice = gets.chomp!)
      #  if choice == '1'
      #    login
      #    break
      #  elsif choice == '2'
      #    signup
      #    break
      #  else
      #    puts Paint['Please type `1` or `2`', :red]
      #    next
      #  end
      #end

    end

  end
end
