$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../lib')

require 'gbip'
require File.dirname(__FILE__) + "/mock_tcpsocket"
require File.dirname(__FILE__) + "/timeout_tcpsocket"

context "A new POS object" do

  setup do
    @valid_username = "user"
    @valid_password = "pass"
    @invalid_password = "word"
    @valid_isbn10 = "1741146712"
    @valid_isbn13 = "9781741146714"
    @valid_isbn13_hash = "9781590599358"
    @notfound_isbn10 = "0571228526"
    @notfound_isbn13 = "9780571228522"
    @valid_isbn10_with_no_warehouses = "0732282721"
  end

  #####################
  #  :first searches
  #####################
  specify "should raise an exception when an invalid username or password is supplied" do
    pos = GBIP::POS.new(@valid_username, @invalid_password, MockTCPSocket)
    lambda { pos.find(:first, @valid_isbn10) }.should raise_error(GBIP::InvalidLoginError)
  end

  specify "should return a GBIP::Title object when queried for a single valid ISBN10" do
    pos = GBIP::POS.new(@valid_username, @valid_password, MockTCPSocket)
    result = pos.find(:first, @valid_isbn10)
    result.should be_a_kind_of(GBIP::Title)
  end

  specify "should return a GBIP::Title object when queried for a single valid ISBN13" do
    pos = GBIP::POS.new(@valid_username, @valid_password, MockTCPSocket)
    result = pos.find(:first, @valid_isbn13)
    result.should be_a_kind_of(GBIP::Title)
  end

  specify "should return a GBIP::Title object when the response contains an extra #" do
    pos = GBIP::POS.new(@valid_username, @valid_password, MockTCPSocket)
    result = pos.find(:first, @valid_isbn13_hash)
    result.should be_a_kind_of(GBIP::Title)
    result.title.should eql("Pro EDI in BizTalk Server 2006 R2:Electronic Document Interchange Solutions")
  end

  specify "should return a GBIP::Title object when querying for a single valid ISBN10 that has no warehouse data" do
    pos = GBIP::POS.new(@valid_username, @valid_password, MockTCPSocket)
    result = pos.find(:first, @valid_isbn10_with_no_warehouses)
    result.should be_a_kind_of(GBIP::Title)
    result.warehouses.should be_empty
  end

  specify "should return a GBIP::Title object when querying for a single valid ISBN10 that has no warehouse data" do
    pos = GBIP::POS.new(@valid_username, @valid_password, MockTCPSocket)
    result = pos.find(:first, @valid_isbn10_with_no_warehouses)
    result.should be_a_kind_of(GBIP::Title)
    result.warehouses.should be_empty
  end

  specify "should return nil when a single ISBN10 not recognised by GBIP is requested" do
    pos = GBIP::POS.new(@valid_username, @valid_password, MockTCPSocket)
    result = pos.find(:first, @notfound_isbn10)
    result.should eql(nil)
  end

  specify "should return nil when a single ISBN13 not recognised by GBIP is requested" do
    pos = GBIP::POS.new(@valid_username, @valid_password, MockTCPSocket)
    result = pos.find(:first, @notfound_isbn13)
    result.should eql(nil)
  end

  specify "should return nil when any object is supplied as an ISBN when searching for :first" do
    pos = GBIP::POS.new(@valid_username, @valid_password, MockTCPSocket)
    result = pos.find(:first, nil)
    result.should eql(nil)

    result = pos.find(:first, 3)
    result.should eql(nil)

    result = pos.find(:first, "23234sdfzsdf3w")
    result.should eql(nil)
  end

  specify "should perform a successful query if the ISBN is provided as a number" do
    pos = GBIP::POS.new(@valid_username, @valid_password, MockTCPSocket)
    result = pos.find(:first, @valid_isbn13)
    result.should be_a_kind_of(GBIP::Title)
  end

  specify "should raise an exception if no reponse is received in a certain amount of time" do
    pos = GBIP::POS.new(@valid_username, @valid_password, TimeoutTCPSocket)
    lambda { pos.find(:first, @valid_isbn13, :timeout => 2) }.should raise_error(Timeout::Error)
  end

  #####################
  #  :all searches
  #####################
  specify "should return a non-empty Array when queried for a single valid ISBN10" do
    pos = GBIP::POS.new(@valid_username, @valid_password, MockTCPSocket)
    result = pos.find(:all, @valid_isbn10)
    result.should be_a_kind_of(Array)
    result.should_not be_empty
  end

  specify "should return a non-empty Array when queried for a single valid ISBN13" do
    pos = GBIP::POS.new(@valid_username, @valid_password, MockTCPSocket)
    result = pos.find(:all, @valid_isbn13)
    result.should be_a_kind_of(Array)
    result.should_not be_empty
  end

  specify "should return an empty Array when a single ISBN10 not recognised by GBIP is requested" do
    pos = GBIP::POS.new(@valid_username, @valid_password, MockTCPSocket)
    result = pos.find(:all, @notfound_isbn10)
    result.should be_a_kind_of(Array)
    result.should be_empty
  end

  specify "should return an empty Array when a single ISBN13 not recognised by GBIP is requested" do
    pos = GBIP::POS.new(@valid_username, @valid_password, MockTCPSocket)
    result = pos.find(:all, @notfound_isbn13)
    result.should be_a_kind_of(Array)
    result.should be_empty
  end

  specify "should return an empty array when any object is supplied as an ISBN when searching for :all" do
    pos = GBIP::POS.new(@valid_username, @valid_password, MockTCPSocket)
    result = pos.find(:all, nil)
    result.should be_a_kind_of(Array)
    result.should be_empty

    result = pos.find(:all, 3)
    result.should be_a_kind_of(Array)
    result.should be_empty

    result = pos.find(:all, "23234sdfzsdf3w")
    result.should be_a_kind_of(Array)
    result.should be_empty
  end

  specify "should perform a successful query if the ISBN is provided as a number to an :all search" do
    pos = GBIP::POS.new(@valid_username, @valid_password, MockTCPSocket)
    result = pos.find(:all, 1741146712)
    result.should be_a_kind_of(Array)
    result.should_not be_empty
  end

  #####################
  #  invalid searches
  #####################
  specify "should raise an exception when an invalid search type is supplied" do
    pos = GBIP::POS.new(@valid_username, @invalid_password, MockTCPSocket)
    lambda { pos.find(nil, @valid_isbn10) }.should raise_error(ArgumentError)
    lambda { pos.find(:last, @valid_isbn10) }.should raise_error(ArgumentError)
    lambda { pos.find(123456, @valid_isbn10) }.should raise_error(ArgumentError)
  end

end
