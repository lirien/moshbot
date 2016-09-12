require_relative '../spec_helper'
require_relative '../../lib/moshbot'
require_relative '../../lib/gifmosh'

describe GifMosh::Gif do
end

describe "#get_fps" do
  it 'returns the correct fps for mp4' do
    mp4 = GifMosh::Gif.new(fixture('good_day_sir.mp4'))
    expect(mp4.fps).to eq 10.18
  end
  it 'returns the correct fps for gif' do
    gif = GifMosh::Gif.new(fixture('cat_tube.gif'))
    expect(gif.fps).to eq 12.5
  end
end

describe "#same_fps" do
  it 'input and output have the same fps' do
    gif = GifMosh::Gif.new(fixture('cat_tube.gif'))
    out_gif = gif.melt
    expect(gif.fps).to eq 12.5
    expect(out_gif.fps).to eq 12.5
    out_gif.destroy
  end
end
