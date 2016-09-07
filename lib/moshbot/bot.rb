require 'twitter'
require 'json'
require 'giphy'
require 'open-uri'
require 'pry'

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
      Giphy::Configuration.configure do |config|
        config.api_key = config_args['giphy_api_key']
      end
    end

    def download(uri, filename: 'giphy.mp4')
      File.open(filename, 'wb') do |fo|
        fo.write open(uri).read
      end
    end

    def first_trending_gif
      result = Giphy.trending
      download result.first.original_image.mp4
      GifMosh::Gif.new('giphy.mp4')
    end

    def mosh(gif: first_trending_gif, dry_run: false)
      # melt the gif
      out_gif = gif.melt
      # post it to twitter
      unless dry_run
        client.update_with_media('', File.new(out_gif.filename))
        out_gif.destroy
      end
      gif.destroy
    end
  end
end
