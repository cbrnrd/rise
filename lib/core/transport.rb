##
# This file handles all communication to the Upto servers
##
require 'colorize'
module Upto
  module Transport

    # Handles uploading files
    class Uploader

      attr_reader :folder_path, :total_files, :include_folder
      attr_accessor :files

      def initialize(folder_path, include_folder=true)
          @folder_path    = folder_path
          @files          = Dir.glob("#{folder_path}/**/*")
          @total_files    = @files.length
          @connection     = TCPSocket.new('0.0.0.0', 5753)
          @include_folder = include_folder
      end

      def upload!(thread_count=5, verbose=false)
        file_number = 0
        mutex = Mutex.new
        threads = []

        puts "Total files: #{total_files.to_s.blue}... uploading (folder #{folder_path} #{include_folder ? '' : 'not '}included)"
        spinner_thread = Thread.new do
          Whirly.start(spinner: 'arrow3') do
            sleep(5)
          end
        end
        thread_count.times do |i|
          threads[i] = Thread.new {
            until files.empty?
              mutex.synchronize do
                file_number += 1
                Thread.current["file_number"] = file_number
              end
              file = files.pop rescue nil
              next unless file

              # Define destination path
              if include_folder
                path = file
              else
                path = file.sub(/^#{folder_path}\//, '')
              end

              puts "[#{Thread.current["file_number"]}/#{total_files}] uploading..." if verbose

              data = File.open(file)

              unless File.directory?(data)
                # DO THE ACTUAL UPLOAD HERE
                #obj = s3_bucket.object(path)
                #obj.put(data, { acl: :public_read, body: data })
                puts files
                @connection.puts("FILENAME:")
                puts "Uploading #{Thread.current["file_number"]}"
              end

              data.close
            end
          }
        end
        threads.each { |t| t.join }
        spinner_thread.join
      end
    end
  end
end
