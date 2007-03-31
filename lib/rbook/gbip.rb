$LOAD_PATH.unshift(File.dirname(__FILE__) + "/../")

# load the files that form this library
require 'rbook/gbip/pos'
require 'rbook/gbip/title'
require 'rbook/gbip/warehouse'
require 'rbook/errors'

# load rubygems
require 'rbook/isbn'

module RBook

  # Ruby classes for searching the globalbooksinprint.com API. This is a 
  # commercial service and requires a registered account to access. More
  # information on the service can be found at the website.
  #
  # = Basic Usage
  #  gbip = RBook::GBIP::POS.new("username", "password")
  #  puts gbip.find("0091835135").inspect
  #
  module GBIP

  end
end
