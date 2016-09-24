require 'fileutils'
require_relative '../spec_helper'
require_relative '../../lib/gifmosh'

describe GifMosh::Avi do
  before(:each) do
    FileUtils.stub(:rm)
    @avi = GifMosh::Avi.new(fixture('meownanna.avi'))
  end

  describe '#mvs' do
    it 'extracts motion vectors from csv' do
      @avi.stub(:extract_mvs) do
        fixture('cat_tube_mvs.csv')
      end

      expect(@avi.mvs.length).to be 46
      expect(@avi.mvs[2].length).to be 422
      expect(@avi.mvs[2].first.source[:x]).to be 8
    end
  end

  describe 'when computing mvs' do
    before(:each) do
      @avi.stub(:mvs) do
        stub_mvs
      end
    end

    it 'returns the frame index with the most mvs' do
      expect(@avi.most_mv_frame).to eq 5
    end

    it 'returns the frame index with the highest sum magnitude' do
      expect(@avi.largest_mv_frame).to eq 1
    end

    it 'returns motion vectors from the last 50 percent of frames' do
      expect(@avi.last_percent_mvs).to be
      {
        4 => [
          GifMosh::MotionVector.new('dstx' => 1, 'dsty' => 1),
          GifMosh::MotionVector.new('dstx' => 1, 'dsty' => 1)
        ],
        5 => [
          GifMosh::MotionVector.new({}),
          GifMosh::MotionVector.new({})
        ],
        6 => [
          GifMosh::MotionVector.new({}),
          GifMosh::MotionVector.new({}),
          GifMosh::MotionVector.new({})
        ]
      }
    end

    it 'returns frame index with most mvs from last 50 percent' do
      expect(@avi.most_mv_frame(@avi.last_percent_mvs)).to eq 5
    end

    it 'returns frame index with highest sum magnitude mvs from last 50 percent' do
      expect(@avi.largest_mv_frame(@avi.last_percent_mvs)).to eq 3
    end
  end
end
