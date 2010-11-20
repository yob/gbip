require "rubygems"
require "bundler"
Bundler.setup

$LOAD_PATH.unshift(File.dirname(__FILE__) + "/../vendor/")

require 'not_a_mock'

RSpec.configure do |config|
  config.mock_with NotAMock::RspecMockFrameworkAdapter
end
