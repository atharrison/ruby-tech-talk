require 'active_support'
require 'active_support/all'
require 'aws-sdk'
require 'graphite-api'
require 'json'
require 'require_all'
require 'pry'
require 'pry-nav'

# Configure AWS      ,
AWS_ACCESS_ID = 'AKIAID76JMMWL6Z2LL6A'
AWS_SECRET_KEY = '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'
AWS.config(
    :access_key_id => AWS_ACCESS_ID,
    :secret_access_key => AWS_SECRET_KEY)


module Techtalk
  # Project-level globals and resources go here

  GRAPHITE_SERVER = "metrics-input.lan.returnpath.net"
  GRAPHITE_PORT = "2003"
  GRAPHITE_PREFIX = "sandbox.rp-tech-talk"
  TECHTALK_S3_BUCKET = 'rp-tech-talk'

  # https://github.com/kontera-technologies/graphite-api/blob/master/README.md
  # https://wiki.corp.returnpath.net/display/rpoperations/Graphite+FAQ
  def self.graphite(prefix=nil)
    GraphiteAPI.new(graphite: "#{GRAPHITE_SERVER}:#{GRAPHITE_PORT}", prefix: GRAPHITE_PREFIX)
  end

  # http://docs.aws.amazon.com/AWSRubySDK/latest/AWS/S3.html
  def self.s3_client
    @s3 ||= AWS::S3.new
    @s3_client ||= S3ScopedClient.new(@s3, TECHTALK_S3_BUCKET)
  end

end

require_all 'lib'
