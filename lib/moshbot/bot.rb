require 'twitter'
require 'json'
require 'giphy'
require 'open-uri'
require 'zalgo'
require_relative '../truncate'

module MoshBot
  class Bot
    attr_accessor :client
    attr_accessor :text
    attr_accessor :out_gif

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
      @text = format_slug result.first.send(:hash)['slug']
      GifMosh::Gif.new('giphy.mp4')
    end

    def format_slug(slug)
      result = slug.split('-')[0...-1]
                   .map(&:capitalize)
                   .join(' ')
      z_result = Zalgo.he_comes(result, up: false, down: false)
      z_result.truncate(140, separator: /\s/, omission: '')
    end

    def mosh(dry_run: false)
      gif = first_trending_gif
      # melt the gif
      @out_gif = gif.melt
      # check the filesize
      if @out_gif.filesize > 3_000_000
        smaller_gif = @out_gif.resize
        @out_gif = smaller_gif
      end
      # post it to twitter
      unless dry_run
        client.update_with_media(@text, File.new(@out_gif.filename))
        @out_gif.destroy
      end
      gif.destroy
    end
  end
end
