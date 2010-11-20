require "rubygems"
require "bundler"
Bundler.setup

require 'not_a_mock'

RSpec.configure do |config|
  config.mock_with NotAMock::RspecMockFrameworkAdapter
end
