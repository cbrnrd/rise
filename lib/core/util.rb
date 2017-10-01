require 'fileutils'
require 'paint'
require 'json'
require 'http'
require 'password'
require 'bcrypt'
require_relative 'constants'

#
# Utility methods
#
module Upto
  module Util

    def self.is_first_run?
      false if File.directory?(File.join(Dir.home, '.upto'))
      true
    end

    def self.setup
      puts Paint["Detected first time setup, creating necessary files...", :blue]
      FileUtils.mkdir(UPTO_DATA_DIR)
      FileUtils.mkdir(File.join(UPTO_DATA_DIR, 'auth'))

      # Get the input from the user
      print Paint["1. Log in\n2. Sign up\n  > ", :bold]
      while (choice = gets.chomp!)
        if choice == "1"
          login
          break
        elsif choice == "2"
          signup
          break
        else
          puts Paint["Please type `1` or `2`", :red]
          next
        end
      end

      File.open(File.join(UPTO_DATA_DIR, 'auth', 'creds.json'), 'w+') do |f|
        f.puts('# This file is used to login to the upto service')
        f.puts('# DO NOT SHARE THIS WITH ANYONE')
      end
    end

  end
end

# We generally don't want to use these anywhere else, so theyre out of the scope of the module
def login

  print "\nEmail: "
  email = gets.chomp!
  puts
  password = Password.get('Password: ')
  BCrypt::Engine.cost = 5  # not too much strain
  hash = BCrypt::Password.create(password)
  res = HTTP.post("http://#{DOMAIN}:#{AUTH_PORT}/login?email=#{email}&hash=#{hash}")
  if res.code == 200
    puts Paint["Login successful!", :green, :bold]
  else
    puts Paint["Login failed!", :red, :bold]
    puts "Printing error: #{res.body}"
  end
end

def signup
  print "\nEmail: "
  email = gets.chomp!
  puts
  password = Password.get('Password: ')
  BCrypt::Engine.cost = 5  # not too much strain
  hash = BCrypt::Password.create(password)
  res = HTTP.post("http://#{DOMAIN}:#{AUTH_PORT}/signup?email=#{email}&hash=#{hash}")
  if res.code == 200
    puts Paint["Signup successful!", :green, :bold]
    File.open(File.join(UPTO_DATA_DIR, 'auth', 'creds.json'), 'a') do |f|
      creds_hash = {
        'email' => email,
        'hash'  => hash
      }
      f.puts(creds_hash.to_json)
    end
  elsif res.code == 409  # user already exists
    puts Paint[res.body, :red]
    return
  end
end
