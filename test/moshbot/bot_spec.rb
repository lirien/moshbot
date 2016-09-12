require_relative '../spec_helper'
require_relative '../../lib/moshbot'

describe MoshBot::Bot do
  it 'should be true' do
    expect(true).to be true
  end

  describe '#new_mentions' do
    it 'should only return the newest tweets' do
      bot = MoshBot::Bot.new

      stub_request(:get, %r{api.twitter.com/1.1/statuses/mentions_timeline.json}).to_return(
        status: 200,
        body: File.new(File.expand_path('../../fixtures', __FILE__) + '/statuses.json'),
        headers: {}
      )
      bot.new_mentions

      # stub http to return 4 tweets, including the old ones
      result = bot.new_mentions
      # Make sure that result only has the last 2 tweets
    end
  end

  describe '#new_gifs' do
    it 'returns only new tweets that contain gifs' do
      bot = MoshBot::Bot.new
      # make new_mentions return 2 tweets, 1 with a gif, 1 without
      result = bot.new_gifs
      # make sure result only has the one that has a gif
    end
  end

  describe '#mosh_gif' do
    it 'moshes it' do
    end
  end

  describe '#post_gif' do
    it 'posts it' do
    end
  end
end
