require 'streamio-ffmpeg'

module AviGif
    #Converts a gif to an avi
    def AviGif.gif2avi inpath,outpath="./output.avi"
        movie = FFMPEG::Movie.new(inpath)
        options = {pix_fmt: "yuv420p",
            custom: %w(-vf scale=trunc(iw/2)*2:trunc(ih/2)*2)}
        movie.transcode(outpath, options)
    end

    #Converts an avi to a gif
    def AviGif.avi2gif inpath,outpath="./output.gif"
        movie = FFMPEG::Movie.new(inpath)
        puts "Here's the avi we input! #{inpath}"
    end
end
