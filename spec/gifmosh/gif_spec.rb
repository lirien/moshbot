require_relative '../spec_helper'
require_relative '../../lib/moshbot'
require_relative '../../lib/gifmosh'

describe GifMosh::Gif do
end

describe "#fps" do
  it 'returns the correct fps for mp4' do
    mp4 = GifMosh::Gif.new(fixture('good_day_sir.mp4'))
    expect(mp4.fps).to eq 10.18
  end
  it 'returns the correct fps for gif' do
    gif = GifMosh::Gif.new(fixture('melted_cat.gif'))
    expect(gif.fps).to eq 10
  end
end

describe "#keep_fps" do
  it 'input and output have the same fps' do
    #convert the mp4 to an avi
    #convert the avi back to a gif
    #confirm fps are the same
    #destroy the created gif
  end
end
