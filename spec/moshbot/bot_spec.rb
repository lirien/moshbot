require_relative '../spec_helper'
require_relative '../../lib/moshbot'

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
end
