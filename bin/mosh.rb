require_relative '../lib/gifmosh'
require_relative '../lib/moshbot'

puts "*** Starting mosh: #{Time.now} ***"
bot = MoshBot::Bot.new
bot.mosh
