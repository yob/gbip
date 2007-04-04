$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../lib')

require 'rbook/gbip'
require File.dirname(__FILE__) + "/mock_tcpsocket"

include RBook

context "A new POS object" do

  setup do
    @valid_username = "user"
    @valid_password = "pass"
    @invalid_password = "word"
    @valid_isbn10 = "1741146712"
    @valid_isbn13 = "9781741146714"
    @notfound_isbn10 = "0571228526"
    @notfound_isbn13 = "9780571228522"
  end

  specify "should raise an exception when an invalid username or password is supplied" do
    pos = GBIP::POS.new(@valid_username, @invalid_password, MockTCPSocket)
    lambda { pos.find(:first, @valid_isbn10) }.should_raise_error(RBook::InvalidLoginError)
  end

  specify "should return a RBook::GBIP::Title object when queried for a valid ISBN10" do
    pos = GBIP::POS.new(@valid_username, @valid_password, MockTCPSocket)
    result = pos.find(:first, @valid_isbn10)
    result.should_be_a_kind_of(RBook::GBIP::Title)
  end

  specify "should return a RBook::GBIP::Title object when queried for a valid ISBN13" do
    pos = GBIP::POS.new(@valid_username, @valid_password, MockTCPSocket)
    result = pos.find(:first, @valid_isbn13)
    result.should_be_a_kind_of(RBook::GBIP::Title)
  end

  specify "should return nil when an ISBN10 not recognised by GBIP is requested" do
    pos = GBIP::POS.new(@valid_username, @valid_password, MockTCPSocket)
    result = pos.find(:first, @notfound_isbn10)
    result.should_be_nil
  end

  specify "should return nil when an ISBN13 not recognised by GBIP is requested" do
    pos = GBIP::POS.new(@valid_username, @valid_password, MockTCPSocket)
    result = pos.find(:first, @notfound_isbn13)
    result.should_be_nil
  end

  specify "should return nil when any object is supplied as an ISBN" do
    pos = GBIP::POS.new(@valid_username, @valid_password, MockTCPSocket)
    result = pos.find(:first, nil)
    result.should_be_nil

    result = pos.find(:first, 3)
    result.should_be_nil

    result = pos.find(:first, "23234sdfzsdf3w")
    result.should_be_nil
  end

  specify "should return perform a successful query if the ISBN is provided as a number" do
    pos = GBIP::POS.new(@valid_username, @valid_password, MockTCPSocket)
    result = pos.find(:first, 1741146712)
    result.should_be_a_kind_of(RBook::GBIP::Title)
  end
end
