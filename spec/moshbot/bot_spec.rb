require_relative '../spec_helper'
require_relative '../../lib/moshbot'
require_relative '../../lib/gifmosh'
require 'zalgo'

describe MoshBot::Bot do
  before(:each) do
    Zalgo.stub(:he_comes) do |string|
      "zalgo #{string}"
    end
    GifMosh.stub(:fps) do
      24
    end
    GifMosh.stub(:width) do
      320
    end
    @bot = MoshBot::Bot.new(fixture('test_config.json'))
    @bot.stub(:update_gif_id)
  end

  describe '#first_trending_gif' do
    it 'does not download the gif if it has already been moshed' do
      GifMosh.stub(:filesize) { 1_000_000 }
      stub_request(:get, %r{api.giphy.com/v1/gifs/trending}).to_return(
        status: 200,
        body: File.new(fixture('giphy/trending.json')),
        headers: {}
      )
      expect(@bot.first_trending_gif(fixture('last_moshed_id_same'))).to be nil
    end

    it 'downloads the first trending gif if there is no mp4' do
      GifMosh.stub(:filesize) { 1_000_000 }
      stub_request(:get, %r{api.giphy.com/v1/gifs/trending}).to_return(
        status: 200,
        body: File.new(fixture('giphy/trending-no-mp4.json')),
        headers: {}
      )

      expect(@bot).to receive(:download).with(URI('http://media2.giphy.com/media/yj5oYHjoIwv28/giphy.gif')) do
        @bot.instance_variable_set(:@filename, fixture('melted_cat.gif'))
      end
      @bot.first_trending_gif(fixture('last_moshed_id_different'))
    end

    it 'downloads the first trending mp4 if there is an mp4' do
      GifMosh.stub(:filesize) { 1_000_000 }
      stub_request(:get, %r{api.giphy.com/v1/gifs/trending}).to_return(
        status: 200,
        body: File.new(fixture('giphy/trending.json')),
        headers: {}
      )

      expect(@bot).to receive(:download).with(URI('http://media2.giphy.com/media/yj5oYHjoIwv28/giphy.mp4')) do
        @bot.instance_variable_set(:@filename, fixture('good_day_sir.mp4'))
      end
      @bot.first_trending_gif(fixture('last_moshed_id_different'))
    end
  end

  describe '#mosh' do
    it 'melts the gif and posts it to twitter' do
      gif = GifMosh::Gif.new(fixture('melted_cat.gif'))
      @bot.stub(:first_trending_gif) { gif }
      @bot.text = 'kitty'
      gif.stub(:destroy)

      expect(gif).to receive(:melt) { gif }
      expect(@bot.client).to receive(:update_with_media).with('kitty', instance_of(File))

      @bot.mosh
    end
    it 'resizes gif if size > 3 mb' do
      gif = GifMosh::Gif.new(fixture('large_out.gif'))
      @bot.stub(:first_trending_gif) { gif }
      gif.stub(:melt) { gif }
      @bot.client.stub(:update_with_media)
      gif.stub(:destroy)

      expect(gif).to receive(:resize) { gif }

      @bot.mosh
    end
  end

  describe '#format_slug' do
    it 'separates the slug and zalgos it' do
      slug = 'a-really-cool-pic-very-very-very-long-amount-of-text-' \
      'some-of-this-will-have-to-be-deleted-to-post-to-twitter-truncate-after-' \
      'one-hundred-forty-characters-please-DELETEME'

      expect(@bot.format_slug(slug)).to eq 'zalgo A Really Cool Pic ' \
          'Very Very Very Long Amount Of Text Some Of This Will Have To Be Deleted ' \
          'To Post To Twitter'
    end

    it 'replaces blank slug text with untitled' do
      slug = ''
      expect(@bot.format_slug(slug)).to eq 'zalgo Untitled'
    end

    it 'replaces nil slug text with untitled' do
      slug = nil
      expect(@bot.format_slug(slug)).to eq 'zalgo Untitled'
    end
  end
end
