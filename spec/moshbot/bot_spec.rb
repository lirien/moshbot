require_relative '../spec_helper'
require_relative '../../lib/moshbot'
require_relative '../../lib/gifmosh'

describe MoshBot::Bot do
  describe '#first_trending_gif' do
    it 'downloads the first trending gif' do
      bot = MoshBot::Bot.new(fixture('config.json'))

      stub_request(:get, %r{api.giphy.com/v1/gifs/trending}).to_return(
        status: 200,
        body: File.new(fixture('giphy/trending.json')),
        headers: {}
      )

      expect(bot).to receive(:download).with(URI('http://media2.giphy.com/media/yj5oYHjoIwv28/giphy.mp4'))
      bot.first_trending_gif
    end
  end

  describe '#mosh' do
    it 'melts the gif and posts it to twitter' do
      bot = MoshBot::Bot.new(fixture('config.json'))
      gif = GifMosh::Gif.new(fixture('melted_cat.gif'))
      gif.stub(:destroy)

      expect(gif).to receive(:melt) { gif }
      expect(bot.client).to receive(:update_with_media).with(instance_of(String), instance_of(File))

      bot.mosh(gif: gif)
    end
  end
end
