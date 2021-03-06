require_relative '../spec_helper'
require_relative '../../lib/moshbot'
require_relative '../../lib/gifmosh'

describe GifMosh::Gif do
  before(:each) do
    GifMosh::Avi.any_instance.stub(:mvs) do
      stub_mvs
    end
  end

  describe '#get_fps' do
    it 'returns the correct fps for a mp4' do
      mp4 = GifMosh::Gif.new(fixture('good_day_sir.mp4'))
      expect(mp4.fps).to eq 10.18
    end

    it 'returns the correct fps for a gif' do
      gif = GifMosh::Gif.new(fixture('cat_tube.gif'))
      expect(gif.fps).to eq 12.5
    end
  end

  describe '#same_fps' do
    it 'creates an output with the same fps' do
      gif = GifMosh::Gif.new(fixture('cat_tube.gif'))
      out_gif = gif.melt
      expect(out_gif.fps).to eq 12.5
      out_gif.destroy
    end
  end

  describe '#resize' do
    it 'resizes itself to make width 200' do
      gif = GifMosh::Gif.new(fixture('cat_tube.gif'))
      smaller_gif = gif.resize
      expect(smaller_gif.width).to eq 200
      smaller_gif.destroy
    end
  end
end
