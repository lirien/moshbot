require 'aviglitch'
require 'fileutils'
require_relative 'avi'

module GifMosh
  class Gif
    attr_reader :filename
    attr_reader :basename

    def initialize(filename)
      @filename = filename
      @basename = File.basename(filename, File.extname(filename))
      @extension = File.extname(filename)
    end

    def to_avi(outpath: "#{@basename}.avi")
      GifMosh.gif2avi(@filename, outpath) unless File.exist? outpath
      Avi.new(outpath)
    end

    def melt(frame: nil, outpath: "#{@basename}_out.gif", repeat: 20)
      avi = to_avi
      melted_avi = avi.melt(frame: frame, repeat: repeat)
      result = melted_avi.to_gif(outpath: outpath)
      avi.destroy
      melted_avi.destroy
      result
    end

    def destroy
      FileUtils.rm(@filename, force: true)
    end
  end
end
