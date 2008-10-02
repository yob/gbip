$LOAD_PATH.unshift(File.dirname(__FILE__) + "/../")

# load the files that form this library
require 'gbip/pos'
require 'gbip/title'
require 'gbip/warehouse'

# load rubygems
require 'rubygems'
require 'rbook/isbn'

# Ruby classes for searching the globalbooksinprint.com API. This is a 
# commercial service and requires a registered account to access. More
# information on the service can be found at the website.
#
# = Basic Usage
#  gbip = RBook::GBIP::POS.new("username", "password")
#  puts gbip.find("0091835135").inspect
#
module GBIP
  class InvalidLoginError  < RuntimeError; end
end
