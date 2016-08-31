# frozen_string_literal: true
require 'aviglitch'
require 'fileutils'

module GifMosh
  class Gif
    def initialize(gifpath)
      @basepath = File.basename(gifpath, File.extname(gifpath))
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
      FileUtils.rm "#{@basepath}.avi", force: true
      FileUtils.rm "#{@basepath}_out.avi", force: true
    end

    def melt_from_frame(frame, outpath = "#{@basepath}_out.gif", repeat = 20)
      create_avi unless File.exist? "#{@basepath}.avi"
      result = @video.frames[0, frame]
      repeat.times do
        result.concat(@video.frames[frame, 1])
      end
      avioutfile = AviGlitch.open result
      avioutfile.output "#{@basepath}_out.avi"
      GifMosh.avi2gif("#{@basepath}_out.avi", outpath)
      remove_avis
    end

    def melt_from_random(outpath = "#{@basepath}_out.gif")
      create_avi unless File.exist? "#{@basepath}.avi"
      melt_from_frame(@pframes.sample, outpath)
    end
  end
end
