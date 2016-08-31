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

    def new_mentions
      timeline = @client.mentions_timeline
      p timeline.map(&:full_text)
      p timeline.map(&:media?)

      timeline.each do |t|
          if t.media?
              p t.media.map(&:media_uri)
          end
      end
      # get timeline
      # read all tweets that are newer than previous newest tweet
      # store newest tweet
      # return new tweets
    end
  end
end
