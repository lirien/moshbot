require 'fileutils'
require 'csv'

module GifMosh
  class MotionVector
    attr_reader :frame
    attr_reader :source

    def initialize(options)
      @frame = options['framenum'].to_i
      @source_frame = options['source'].to_i

      @block = {
        width: options['blockw'].to_i,
        height: options['blockh'].to_i
      }

      @source = {
        x: options['srcx'].to_i,
        y: options['srcy'].to_i
      }

      @destination = {
        x: options['dstx'].to_i,
        y: options['dsty'].to_i
      }

      @flags = options['flags']
    end

    def magnitude
      w = @destination[:x] - @source[:x]
      h = @destination[:y] - @source[:y]
      Math.sqrt((w * w) + (h * h))
    end
  end
end
