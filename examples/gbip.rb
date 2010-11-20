# assuming you have rbook installed via rubygems,
# in a regular script, replace the following require
# line with these 2 lines:
#   require 'rubygems'
#   require 'rbook/gbip'

$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'
require 'gbip'

gbip = GBIP::POS.new("username", "password")

puts gbip.find(:first, "0732282721").to_yaml
#puts gbip.find(:first, "0091835135").to_yaml
#puts gbip.find(:first, "1741146712").to_yaml
