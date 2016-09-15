require 'streamio-ffmpeg'
require 'rmagick'
require 'fileutils'
require_relative 'gifmosh/gif'
require_relative 'gifmosh/avi'

module GifMosh
  # Converts a gif (or mp4!) to an avi
  def self.gif2avi(inpath, outpath = './output.avi')
    movie = FFMPEG::Movie.new(inpath)
    fps = movie.frame_rate.to_f.round(2)
    options = { pix_fmt: 'yuv420p', fps: fps,
                custom: %w(-vf scale=trunc(iw/2)*2:trunc(ih/2)*2) }
    movie.transcode(outpath, options)
  end

  # Converts an avi to a gif
  def self.avi2gif(inpath, outpath = './output.gif', fps = nil, width = nil)
    movie = FFMPEG::Movie.new(inpath)
    fps ||= movie.frame_rate.to_f.round(2)
    FileUtils.rm_r Dir.glob('frames/*')
    Dir.mkdir('frames') unless Dir.exist?('frames')
    options = { flags: 'lanczos', fps: fps,
                custom: %w(-vf scale=320:-1:) }
    transcoder_options = { validate: false }
    movie.transcode('frames/ffout%03d.png', options, transcoder_options)
    image = Magick::ImageList.new(*Dir.glob('frames/*'))
    if width
      image.each do |x|
        x.change_geometry!("#{width}x1024") { |cols, rows, img| img.resize!(cols, rows) }
      end
    end
    image.coalesce
    image.optimize_layers Magick::OptimizeLayer
    image.delay = 1 / fps * 100
    image.write(outpath)
    FileUtils.rm_r Dir.glob('frames/*')
    FileUtils.rmdir 'frames'
    outpath
  end

  def self.fps(inpath)
    movie = FFMPEG::Movie.new(inpath)
    movie.frame_rate.to_f.round(2)
  end

  def self.width(inpath)
    movie = FFMPEG::Movie.new(inpath)
    movie.width
  end
end
