require 'aviglitch'
require_relative 'avigif'

module GifGlitch
    class Gif
        attr_reader :gifpath
        def initialize gifpath
            @avipath = "#{File.basename(gifpath,File.extname(gifpath))}.avi"
            AviGif.gif2avi(gifpath,@avipath)
        end
    end
end
