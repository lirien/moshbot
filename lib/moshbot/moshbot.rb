# frozen_string_literal: true
require 'twitter'
require 'json'

module MoshBot
  class Bot
    attr_accessor :client
    def initialize(configpath = 'config.json')
      configfile = File.read(configpath)
      config_args = JSON.parse(configfile)
      @client = Twitter::REST::Client.new do |config|
        config.consumer_key        = config_args['consumer_key']
        config.consumer_secret     = config_args['consumer_secret']
        config.access_token        = config_args['access_token_key']
        config.access_token_secret = config_args['access_token_secret']
      end
    end
  end
end
