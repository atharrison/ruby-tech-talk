require 'thor'

module Techtalk
  class Cli < Thor

    namespace :techtalk

    desc "test", "Confirm that I can execute the CLI"
    def test
      puts "Test passes!"
    end

    desc "solve", "Solve a problem"
    def solve
      prefix = 'feeds/subject_line_stream/2014/24/2014-06-18/'
      Processor.new(s3_prefix: prefix).process
    end

    desc "pry", "Start a pry session"
    def pry
      binding.pry
    end

  end
end
