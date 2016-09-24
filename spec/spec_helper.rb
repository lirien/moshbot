require 'webmock/rspec'
WebMock.disable_net_connect!(allow_localhost: true)

def fixture(filename)
  File.expand_path("../fixtures/#{filename}", __FILE__)
end

def stub_mvs
  {
    2 => [
      GifMosh::MotionVector.new('dstx' => 10, 'dsty' => 10)
    ],
    3 => [
      GifMosh::MotionVector.new({}),
      GifMosh::MotionVector.new({}),
      GifMosh::MotionVector.new({}),
      GifMosh::MotionVector.new({})
    ],
    4 => [
      GifMosh::MotionVector.new('dstx' => 5, 'dsty' => 5)
    ],
    5 => [
      GifMosh::MotionVector.new({}),
      GifMosh::MotionVector.new({})
    ],
    6 => [
      GifMosh::MotionVector.new('dstx' => 1, 'dsty' => 1),
      GifMosh::MotionVector.new('dstx' => 1, 'dsty' => 1),
      GifMosh::MotionVector.new('dstx' => 1, 'dsty' => 1)
    ]
  }
end
