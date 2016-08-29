require_relative 'lib/avigif'
require 'aviglitch'

AviGif.gif2avi 'cat_tube.gif', 'cat_tube.avi'
AviGif.avi2gif 'cat_tube.avi', 'cat_tube_out.gif'
