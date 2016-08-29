require_relative 'lib/gifmosh'

cat_mosh = GifMosh::Gif.new("cat_tube.gif")
wonka_mosh = GifMosh::Gif.new("good_day_sir.mp4")
cat_mosh.melt_from_frame(6, "cat_tube_out_1.gif")
cat_mosh.melt_from_random("cat_tube_out_2.gif")
wonka_mosh.melt_from_random("wonka_mosh.gif")
