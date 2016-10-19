require 'aviglitch'
require 'fileutils'
require 'csv'

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

    def most_mv_frame(motion_vectors = nil)
      motion_vectors ||= mvs
      current_max = 0
      largest_frame = 0
      motion_vectors.each do |frame, mv_list|
        nonzero = mv_list.reject { |mv| mv.magnitude.zero? }
        if nonzero.length > current_max
          largest_frame = frame
          current_max = nonzero.length
        end
      end
      largest_frame - 1
    end

    def largest_mv_frame(motion_vectors = nil)
      motion_vectors ||= mvs
      current_max = 0
      largest_frame = 0
      motion_vectors.each do |frame, mv_list|
        sum = mv_list.map(&:magnitude).reduce(0, :+)
        if sum > current_max
          largest_frame = frame
          current_max = sum
        end
      end
      largest_frame - 1
    end

    def last_percent_mvs(percent = 0.5)
      from_frame = (mvs.keys.last * (1 - percent)).to_i
      mvs.reject { |key, _| key <= from_frame }
    end

    def melt(frame: nil, repeat: 20)
      frame ||= most_mv_frame(last_percent_mvs)
      result = @video.frames[0, frame]
      repeat.times do
        result.concat(@video.frames[frame, 1])
      end

      AviGlitch.open(result).output(avi_outpath)
      Avi.new(avi_outpath)
    end

    def to_gif(fps: nil)
      gifpath, fps, width, filesize = GifMosh.file2gif(@filename, gif_outpath, fps)
      Gif.new(gifpath, fps, width, filesize)
    end

    def mvs
      return @mvs unless @mvs.nil?
      @mvs = Hash.new { |h, k| h[k] = [] }

      csv = extract_mvs
      CSV.foreach(csv, headers: true) do |row|
        hash = row.to_hash
        @mvs[hash['framenum'].to_i] << MotionVector.new(hash)
      end

      FileUtils.rm(csv, force: true)

      @mvs
    end

    def extract_mvs
      tmpfile = "#{@basename}_mvs.csv"
      `./bin/extract_mvs #{@filename} > #{tmpfile}`
      tmpfile
    end

    def destroy
      FileUtils.rm(@filename, force: true)
    end

    def gif_outpath
      "#{@basename}.gif"
    end

    def avi_outpath
      "#{@basename}_out.avi"
    end
  end
end
