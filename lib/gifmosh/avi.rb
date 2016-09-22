require 'aviglitch'
require 'fileutils'
require 'csv'
require_relative '../percent_elements.rb'

module GifMosh
  class Avi
    def initialize(filename)
      @basename = File.basename(filename, File.extname(filename))
      @extension = File.extname(filename)
      @filename = filename
      @video = AviGlitch.open(@filename)
      parse_frames
    end

    def parse_frames
      @pframes = []
      @iframes = []

      @video.frames.each_with_index do |frame, index|
        @pframes.push(index) if frame.is_pframe?
        @iframes.push(index) if frame.is_iframe?
      end
    end

    def melt(frame: nil, outpath: "#{@basename}_out.avi", repeat: 20)
      frame ||= @pframes.percent_elements(70).sample
      result = @video.frames[0, frame]
      repeat.times do
        result.concat(@video.frames[frame, 1])
      end

      AviGlitch.open(result).output(outpath)
      Avi.new(outpath)
    end

    def to_gif(outpath: "#{@basename}_out.gif", fps: nil, width: nil)
      GifMosh.file2gif(@filename, outpath, fps, width)
      Gif.new(outpath)
    end

    def mvs(inpath: @filename)
      outpath = "#{@basename}_mvs.csv"
      GifMosh.extract_mvs(inpath, outpath)
      mv_array = CSV.read(outpath)
      FileUtils.rm(outpath, force: true)
      mv_array
    end

    def destroy
      FileUtils.rm(@filename, force: true)
    end
  end
end
