require_relative '../spec_helper'
require_relative '../../lib/gifmosh'

describe GifMosh::MotionVector do
  describe '#magnitude' do
    it 'computes the magnitude from the source and destination points' do
      mv = GifMosh::MotionVector.new(
        'srcx' => 0,
        'srcy' => 0,
        'dstx' => 3,
        'dsty' => 4
      )
      expect(mv.magnitude).to eq 5
    end
  end
end
