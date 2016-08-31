require_relative 'lib/gifmosh'
require_relative 'lib/moshbot'
require 'open-uri'

cat_tube = GifMosh::Gif.new('cat_tube.gif')
cat_tube.melt(frame: 6, outpath: 'cat_tube_out.gif')

bot = MoshBot::Bot.new("config.json")
timeline = bot.client.mentions_timeline
p timeline.map(&:full_text)
p timeline.map(&:media?)

timeline.each do |t|
    if t.media?
        p t.media.map(&:media_uri)
    end
end

# File.open('cat.gif', 'wb') do |fo|
#   fo.write open("http://blah.gif").read
# end
