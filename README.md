# GBIP

**UNMAINTAINED: this library is unmaintained**

globalbooksinprint.com is a leading source of bibliographic data.
Most clients access the database via the web interface, however there
is a TCP socket based API available apon request.

This library is a small convenience layer for querying the API and viewing
the results in an object tree.

## Installation

    gem install gbip

## Usage

    require 'gbip'

    gbip = GBIP::POS.new("username", "password")
    puts gbip.find(:first, "0732282721").inspect
    puts gbip.find(:first, "0732282721").to_yaml

## Disclaimer

I am in no way affiliated with Bowker, the operators of globalbooksinprint.com.
Please contact them with questions about the service and how to obtain an account.

## Contact

Questions, comments and patches welcome. jimmy _at_ deefa _dot_ com
