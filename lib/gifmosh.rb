require 'aviglitch'
require 'streamio-ffmpeg'
require 'rmagick'
require 'fileutils'

module GifMosh
    class Gif
        def initialize gifpath
            @basepath = File.basename(gifpath,File.extname(gifpath))
            @extension = File.extname(gifpath)
        end

        def create_avi
            GifMosh.gif2avi("#{@basepath}#{@extension}", "#{@basepath}.avi")
            @video = AviGlitch.open "#{@basepath}.avi"
            @pframes = []
            @iframes = []

            @length = @video.frames.size

            @video.frames.each_with_index do |frame, index|
              @pframes.push(index) if frame.is_pframe?
              @iframes.push(index) if frame.is_iframe?
            end
        end

        def remove_avis
            FileUtils.rm "#{@basepath}.avi", :force => true
            FileUtils.rm "#{@basepath}_out.avi", :force => true
        end

        def melt_from_frame frame,outpath="#{@basepath}_out.gif",repeat=20
            if !File.exist? "#{@basepath}.avi"
                create_avi
            end
            result = @video.frames[0, frame]
            repeat.times do
              result.concat(@video.frames[frame, 1])
            end
            avioutfile = AviGlitch.open result
            avioutfile.output "#{@basepath}_out.avi"
            GifMosh.avi2gif("#{@basepath}_out.avi", outpath)
            remove_avis
        end

        def melt_from_random outpath="#{@basepath}_out.gif"
            if !File.exist? "#{@basepath}.avi"
                create_avi
            end
            melt_from_frame(@pframes.sample, outpath)
        end

    end

    #Converts a gif (or mp4!) to an avi
    def GifMosh.gif2avi inpath,outpath="./output.avi"
        movie = FFMPEG::Movie.new(inpath)
        options = {pix_fmt: "yuv420p",
            custom: %w(-vf scale=trunc(iw/2)*2:trunc(ih/2)*2)}
        movie.transcode(outpath, options)
    end

    #Converts an avi to a gif
    def GifMosh.avi2gif inpath,outpath="./output.gif"
        movie = FFMPEG::Movie.new(inpath)
        Dir.mkdir("frames")
        options = {flags: "lanczos", fps: 15,
            custom: %w(-vf scale=320:-1:)}
        transcoder_options = { validate: false }
        movie.transcode("frames/ffout%03d.png", options, transcoder_options)

        image = Magick::ImageList.new(*Dir.glob("frames/*"))
        image.coalesce
        image.optimize_layers Magick::OptimizeLayer
        image.write(outpath)
        FileUtils.rm_r Dir.glob("frames/*")
        FileUtils.rmdir "frames"
        return outpath
    end

end
