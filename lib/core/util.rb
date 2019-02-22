require 'fileutils'
require 'paint'
require 'json'
require 'http'
require 'bcrypt'
require 'io/console'
require 'whirly'
require 'os'
require 'json'
require 'credit_card_validations'
require_relative 'constants'

module Rise
  #
  # Utility methods
  #
  module Util
    #
    # Checks if rise is being run for the first time
    #
    def self.first_run?
      !File.directory?(File.join(Dir.home, '.rise'))
    end

    #
    # 1 = git, 2 = gem, 3 = unknown
    #
    def self.git_or_gem?
      gem = nil
      return 1 if File.exist?(File.join(Rise::Constants::RISE_DIR, '.git'))
      if OS.windows?
        gem = system('which gem > NUL')
      else
        gem = system('which gem > /dev/null')
      end
      return 2 if gem
      3
    end

    #
    # Check for a new version of the gem
    #
    def self.check_for_update!
      src = Rise::Util.git_or_gem?
      if src == 2
        Rise::Text.vputs("Update source: RubyGems")
      elsif src == 1
        Rise::Text.vputs("Update source: git")
      else
        Rise::Text.vputs("Update source: unknown")
      end

      begin
        if src == 2  # if the gem was downloaded from rubygems
          current_version = JSON.parse(HTTP.get('https://rubygems.org/api/v1/versions/rise-cli/latest.json'))['version']

          current_version_i = current_version.gsub('.', '').to_i

          if current_version_i > Rise::Constants::VERSION.gsub('.', '').to_i
            Whirly.start(
              spinner: 'line',
              status: "New version available (#{Paint[Rise::Constants::VERSION, 'red']} -> #{Paint[current_version, '#3498db']}), updating..."
            ) do
              system("gem install rise-cli")
              puts Paint["Update complete, just run #{Paint['`rise`', '#3498db']} to deploy"]
            end
          end
        elsif src == 1
          Rise::Text.vputs("It seems you're on bleeding edge, fetching new changes...")
          Rise::Text.vputs("Updating from #{`git show --no-color --oneline -s`.split(' ')[0]} to #{`git rev-parse --short HEAD`}")
          `git pull`
          puts Paint["Update complete, just run #{Paint['`rise`', '#3498db']} to deploy"]
        end
      rescue StandardError => e
        puts "Unable to check for updates. Error: #{Paint[e.message, 'red']}"
        exit 1
      end
    end

    #
    # Creates all of the necessary files and login information
    #
    def self.setup(first = true)
      if first
        puts Paint['Detected first time setup, creating necessary files...', :blue]
        FileUtils.mkdir(RISE_DATA_DIR)
        FileUtils.mkdir(File.join(RISE_DATA_DIR, 'auth'))
      end

      puts Paint['Create a password to secure your uploads.', :bold]
      pw = Rise::Util.signup
      while (length = pw.length)
        break if length > 8
        puts Paint["Password not long enough,
          it has to be longer than 8 characters\n", :red]
          pw = Rise::Util.signup
      end
      File.open(File.join(RISE_DATA_DIR, 'auth', 'creds.json'), 'w') do |f|
        Rise::Text.vputs("\nWriting hash to creds.json...")
        creds_hash = { 'hash' => BCrypt::Password.create(pw) }
        f.puts(JSON.pretty_generate(creds_hash))
      end
      puts "\nAll done!\nRun #{Paint['`rise`', '#3498db']} to deploy"
    end

    def self.signup
      print 'Password: '
      STDIN.noecho(&:gets).chomp
    end

    #
    # Opens +url+ in a web browser if possible
    #
    def self.open_deployment_in_browser(url)
      if OS.windows?
        system("START \"\" \"#{url}\"")
      else
        system("open #{url}")
      end
    end


    # @param number [String] the credit card number to add
    def self.add_cc_number(number)
      if !number.is_a?(String)
        raise ArgumentError, '`number` must be of type String'
      end

      if !CreditCardValidations::Detector.new(number).valid?
        puts Paint['Credit card is not valid']
        return
      end

      File.open(File.join(RISE_DIR, 'auth', 'payment', 'cc.json'), 'w') do |c|
        c.puts(JSON.pretty_generate({'cc' => number}))
      end

      # TODO make a request to the backend to store the cc in db

      puts 'Credit card stored for later use.'
    end

  end
end
