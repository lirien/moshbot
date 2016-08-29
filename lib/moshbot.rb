require 'twitter'
require 'json'

module MoshBot
    class Bot
        def initialize configpath="../config.json"
            configfile = File.read(configpath)
            config = JSON.parse(configfile)
        end
    end
end
