require_relative 'lib/gifmosh'

cat_mosh = GifMosh::Gif.new("cat_tube.gif")
cat_mosh.melt_from_frame(6, "cat_tube_out_1.gif")
cat_mosh.melt_from_frame(13, "cat_tube_out_2.gif")
