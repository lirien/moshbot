require 'aviglitch'
require 'fileutils'
require_relative 'avi'

module GifMosh
  class Gif
    def initialize(filename)
      @filename = filename
      @basename = File.basename(filename, File.extname(filename))
      @extension = File.extname(filename)
    end

    def to_avi(outpath: "#{@basename}.avi")
      GifMosh.gif2avi(@filename, outpath) unless File.exist? outpath
      Avi.new(outpath)
    end

    def melt(frame:, outpath: "#{@basename}_out.gif", repeat: 20)
      avi = to_avi
      melted_avi = avi.melt(frame: frame, repeat: repeat)
      result = melted_avi.to_gif(outpath: outpath)
      avi.destroy
      melted_avi.destroy
      result
    end
  end
end
