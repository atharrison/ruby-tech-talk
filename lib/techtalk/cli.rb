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
      #Your code goes here
    end

    desc "pry", "Start a pry session"
    def pry
      binding.pry
    end

  end
end
