require 'aviglitch'
require 'fileutils'
require 'streamio-ffmpeg'
require_relative 'avi'

module GifMosh
  class Gif
    attr_reader :filename
    attr_reader :basename
    attr_reader :fps
    attr_reader :width
    attr_reader :filesize

    def initialize(filename, fps = nil, width = nil, filesize = nil)
      @filename = filename
      @basename = File.basename(filename, File.extname(filename))
      @extension = File.extname(filename)
      @fps = fps
      @width = width
      @filesize = filesize
      return unless @fps.nil? || @width.nil? || @filesize.nil?
      movie = FFMPEG::Movie.new(filename)
      @fps = movie.frame_rate.to_f.round(2)
      @width = movie.width
      @filesize = movie.size
    end

    def to_avi(outpath: "#{@basename}.avi")
      GifMosh.file2avi(@filename, outpath) unless File.exist? outpath
      Avi.new(outpath)
    end

    def melt(frame: nil, outpath: "#{@basename}_out.gif", repeat: 2 * @fps.round)
      avi = to_avi
      melted_avi = avi.melt(frame: frame, repeat: repeat)
      result = melted_avi.to_gif(outpath: outpath)
      avi.destroy
      melted_avi.destroy
      result
    end

    def resize(inpath: @filename, outpath: "#{@basename}_small.gif",
               width: 200)
      filename, fps, width, filesize = GifMosh.file2gif(inpath, outpath, nil, width)
      Gif.new(filename, fps, width, filesize)
    end

    def destroy
      FileUtils.rm(@filename, force: true)
    end
  end
end
