require 'not_a_mock'

Spec::Runner.configure do |config|
  config.mock_with NotAMock::RspecMockFrameworkAdapter
end
