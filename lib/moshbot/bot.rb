require 'twitter'
require 'json'
require 'giphy'
require 'open-uri'
require 'zalgo'
require 'uri'
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

    def download(uri)
      @filename = File.basename(uri.path)
      File.open(@filename, 'wb') do |fo|
        fo.write open(uri).read
      end
    end

    def first_trending_gif(last_moshed_id_path = './last_moshed_id')
      result = Giphy.trending
      id = result.first.id
      if last_moshed_was_same(id, last_moshed_id_path)
        print "#{Time.now}: The same gif was moshed last time; abort \n"
        return nil
      end
      original_image = result.first.original_image
      uri = if !original_image.mp4 || original_image.mp4.to_s.empty?
              original_image.url
            else
              original_image.mp4
            end
      print "URI: #{uri} \n"
      download uri
      @text = format_slug result.first.send(:hash)['slug']
      GifMosh::Gif.new(@filename)
    end

    def last_moshed_was_same(id, last_moshed_id_path = './last_moshed_id')
      unless File.exist?(last_moshed_id_path)
        update_gif_id(id, last_moshed_id_path)
        return false
      end
      f = File.new(last_moshed_id_path, 'r')
      prev_id = f.read.chomp
      f.close
      return true unless prev_id != id
      update_gif_id(id, last_moshed_id_path)
      false
    end

    def update_gif_id(id, path)
      f = File.new(path, 'w+')
      f.write(id)
      f.close
    end

    def format_slug(slug)
      slug ||= ''
      result = slug.split('-')[0...-1]
                   .map(&:capitalize)
                   .join(' ')
      result = 'Untitled' if result.empty?
      z_result = Zalgo.he_comes(result, up: false, down: false)
      z_result.truncate(118, separator: /\s/, omission: '')
    end

    def mosh(dry_run: false)
      gif = first_trending_gif
      return unless gif
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
