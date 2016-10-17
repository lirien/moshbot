require 'aviglitch'
require 'fileutils'
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

    def resize(outpath: "#{@basename}_small.gif", width: 200)
      image_list.each do |x|
        x.change_geometry!("#{width}x1024") { |cols, rows, img| img.resize!(cols, rows) }
      end

      image_list.coalesce
      image_list.optimize_layers Magick::OptimizeLayer
      image_list.delay = 1 / @fps * 100
      image_list.write(outpath)

      Gif.new(outpath, @fps, width, File.new(outpath).size)
    end

    def frame_count
      image_list.length
    end

    def image_list
      return @image_list unless @image_list.nil?
      @image_list = Magick::ImageList.new(@filename)
    end

    def destroy
      FileUtils.rm(@filename, force: true)
    end
  end
end
