# assuming you have rbook installed via rubygems,
# in a regular script, replace the following require
# line with these 2 lines:
#   require 'rubygems'
#   require 'rbook/gbip'

$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'
require 'rbook/gbip'

gbip = RBook::GBIP::POS.new("username", "password")

#puts gbip.find("0091835135").inspect
puts gbip.find(:first, "1741146712").inspect

