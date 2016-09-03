require_relative '../lib/gifmosh'
require_relative '../lib/moshbot'
require 'giphy'
require 'yaml'
require 'open-uri'
require 'pry'

# cat_tube = GifMosh::Gif.new('cat_tube.gif')
# cat_tube.melt(frame: 6, outpath: 'cat_tube_out.gif')

# bot = MoshBot::Bot.new
# Pry::ColorPrinter.pp Giphy.trending
#

# timeline = bot.client.mentions_timeline
# p timeline.map(&:full_text)
# p timeline.map(&:media?)
#
# # timeline.each do |t|
# #     if t.media?
# #         p t.media.map(&:media_uri)
# #     end
# # end

# File.open('sarah.mp4', 'wb') do |fo|
#   fo.write open('http://media2.giphy.com//media//yj5oYHjoIwv28//giphy.mp4').read
# end
#
# GifMosh::Gif.new('sarah.mp4').melt
