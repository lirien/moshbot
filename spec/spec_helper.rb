require 'webmock/rspec'
WebMock.disable_net_connect!(allow_localhost: true)

def fixture(filename)
  File.expand_path("../fixtures/#{filename}", __FILE__)
end
