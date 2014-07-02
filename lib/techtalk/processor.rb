module Techtalk
  class Processor

    attr_accessor :s3_prefix

    def initialize(options = {})
      @s3_prefix = options[:s3_prefix]

    end

    def process
      #binding.pry
      s3_client.keys(prefix: s3_prefix).each do |key|
        contents = s3_client.get(key)
        data = JSON.parse(contents)
      end
    end

    def s3_client
      Techtalk.s3_client
    end
  end
end
