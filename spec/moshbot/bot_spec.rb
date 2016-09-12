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
    @bot = MoshBot::Bot.new(fixture('config.json'))
  end

  describe '#first_trending_gif' do
    it 'downloads the first trending gif' do
      stub_request(:get, %r{api.giphy.com/v1/gifs/trending}).to_return(
        status: 200,
        body: File.new(fixture('giphy/trending.json')),
        headers: {}
      )

      expect(@bot).to receive(:download).with(URI('http://media2.giphy.com/media/yj5oYHjoIwv28/giphy.mp4'))
      @bot.first_trending_gif
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
  end

  describe '#format_slug' do
    it 'separates the slug and zalgos it' do
      slug = 'a-really-cool-pic-very-very-very-long-amount-of-text-' \
      'some-of-this-will-have-to-be-deleted-to-post-to-twitter-truncate-after-' \
      'one-hundred-forty-characters-please-DELETEME'

      expect(@bot.format_slug(slug)).to eq 'zalgo A Really Cool Pic ' \
          'Very Very Very Long Amount Of Text Some Of This Will Have To Be Deleted ' \
          'To Post To Twitter Truncate After One'
    end
  end
end
