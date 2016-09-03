require 'aviglitch'
require 'fileutils'

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
      frame ||= @pframes.sample
      result = @video.frames[0, frame]
      repeat.times do
        result.concat(@video.frames[frame, 1])
      end

      AviGlitch.open(result).output(outpath)
      Avi.new(outpath)
    end

    def to_gif(outpath: "#{@basename}_out.gif")
      GifMosh.avi2gif(@filename, outpath)
      Gif.new(outpath)
    end

    def destroy
      FileUtils.rm(@filename, force: true)
    end
  end
end
