$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../lib')

require 'gbip'
require File.dirname(__FILE__) + "/spec_helper"

describe "A new POS object" do

  before(:all) do
    @username = "user"
    @password = "pass"
    @isbn10   = "1741146712"
    @isbn13   = "9781741146714"
  end

  #####################
  #  :first searches
  #####################

  it "should raise an exception when an invalid request is made" do
    # Mock TCPSocket to return an invalid request error code
    data = File.read(File.dirname(__FILE__) + "/responses/invalid_account.txt").strip
    socket = TCPSocket.stub_instance(:print => true, :close => true, :gets => data)
    TCPSocket.stub_method(:new => socket)

    pos = GBIP::POS.new(@username, @password)
    lambda { pos.find(:first, @isbn10) }.should raise_error(GBIP::InvalidRequestError)
  end

  it "should raise an exception when an invalid username or password is supplied" do
    # Mock TCPSocket to return an invalid login error code
    data = File.read(File.dirname(__FILE__) + "/responses/invalid_login.txt").strip
    socket = TCPSocket.stub_instance(:print => true, :close => true, :gets => data)
    TCPSocket.stub_method(:new => socket)

    pos = GBIP::POS.new(@valid_username, @invalid_password)
    lambda { pos.find(:first, @isbn10) }.should raise_error(GBIP::InvalidLoginError)
  end

  it "should raise an exception when an bad data is requested" do
    # Mock TCPSocket to return a bad data error code
    data = File.read(File.dirname(__FILE__) + "/responses/invalid_bad_data.txt").strip
    socket = TCPSocket.stub_instance(:print => true, :close => true, :gets => data)
    TCPSocket.stub_method(:new => socket)

    pos = GBIP::POS.new(@valid_username, @invalid_password)
    lambda { pos.find(:first, @isbn10) }.should raise_error(GBIP::InvalidRequestError)
  end

  it "should raise an exception when an invalid request version is used" do
    # Mock TCPSocket to return an invalid request version error code
    data = File.read(File.dirname(__FILE__) + "/responses/invalid_request.txt").strip
    socket = TCPSocket.stub_instance(:print => true, :close => true, :gets => data)
    TCPSocket.stub_method(:new => socket)

    pos = GBIP::POS.new(@valid_username, @invalid_password)
    lambda { pos.find(:first, @isbn10) }.should raise_error(GBIP::InvalidRequestError)
  end

  it "should raise an exception when a the GBIP API system is unavailable" do
    # Mock TCPSocket to return a system unavailable error code
    data = File.read(File.dirname(__FILE__) + "/responses/invalid_system_unavailable.txt").strip
    socket = TCPSocket.stub_instance(:print => true, :close => true, :gets => data)
    TCPSocket.stub_method(:new => socket)

    pos = GBIP::POS.new(@valid_username, @invalid_password)
    lambda { pos.find(:first, @isbn10) }.should raise_error(GBIP::SystemUnavailableError)
  end

  it "should return a GBIP::Title object when queried for a single valid ISBN10" do
    # Mock TCPSocket to return a single matching title
    data = File.read(File.dirname(__FILE__) + "/responses/single_result.txt").strip
    socket = TCPSocket.stub_instance(:print => true, :close => true, :gets => data)
    TCPSocket.stub_method(:new => socket)

    pos = GBIP::POS.new(@username, @password)
    result = pos.find(:first, @isbn10)

    # check that a singlular result is returned, not an array
    result.should be_a_kind_of(GBIP::Title)

    # TODO: check that our request was for an isbn13
    socket.should have_received(:print)
  end

  it "should return a GBIP::Title object when queried for a single valid ISBN13" do
    # Mock TCPSocket to return a single matching title
    data = File.read(File.dirname(__FILE__) + "/responses/single_result.txt").strip
    socket = TCPSocket.stub_instance(:print => true, :close => true, :gets => data)
    TCPSocket.stub_method(:new => socket)

    pos = GBIP::POS.new(@valid_username, @valid_password)
    result = pos.find(:first, @isbn13)
    result.should be_a_kind_of(GBIP::Title)

    # TODO: check that our request was for an isbn13
    socket.should have_received(:print)
  end

  it "should return a GBIP::Title object when the response contains an extra #" do
    # Mock TCPSocket to return a single matching title that uses a # for its currency
    # sign, as well as a record seperator
    data = File.read(File.dirname(__FILE__) + "/responses/single_result2.txt").strip
    socket = TCPSocket.stub_instance(:print => true, :close => true, :gets => data)
    TCPSocket.stub_method(:new => socket)

    pos = GBIP::POS.new(@username, @password)
    result = pos.find(:first, @isbn13)
    result.should be_a_kind_of(GBIP::Title)
    result.title.should eql("Pro EDI in BizTalk Server 2006 R2:Electronic Document Interchange Solutions")
  end

  it "should return a GBIP::Title object when querying for a single valid ISBN10 that has no warehouse data" do
    # Mock TCPSocket to return a single matching title that lists no warehouses 
    data = File.read(File.dirname(__FILE__) + "/responses/no_warehouses.txt").strip
    socket = TCPSocket.stub_instance(:print => true, :close => true, :gets => data)
    TCPSocket.stub_method(:new => socket)

    pos = GBIP::POS.new(@username, @password)
    result = pos.find(:first, @isbn10)
    result.should be_a_kind_of(GBIP::Title)
    result.warehouses.should be_empty
  end

  it "should return nil when a single ISBN10 not recognised by GBIP is requested" do
    # Mock TCPSocket to return a valid response with no matching titles
    data = File.read(File.dirname(__FILE__) + "/responses/no_result.txt").strip
    socket = TCPSocket.stub_instance(:print => true, :close => true, :gets => data)
    TCPSocket.stub_method(:new => socket)

    pos = GBIP::POS.new(@username, @password)
    result = pos.find(:first, @isbn10)
    result.should eql(nil)
  end

  it "should return nil when a single ISBN13 not recognised by GBIP is requested" do
    # Mock TCPSocket to return a valid response with no matching titles
    data = File.read(File.dirname(__FILE__) + "/responses/no_result.txt").strip
    socket = TCPSocket.stub_instance(:print => true, :close => true, :gets => data)
    TCPSocket.stub_method(:new => socket)

    pos = GBIP::POS.new(@username, @password)
    result = pos.find(:first, @isbn13)
    result.should eql(nil)
  end

  it "should return nil when any object is supplied as an ISBN when searching for :first" do
    pos = GBIP::POS.new(@username, @password)
    result = pos.find(:first, nil)
    result.should eql(nil)

    result = pos.find(:first, 3)
    result.should eql(nil)

    result = pos.find(:first, "23234sdfzsdf3w")
    result.should eql(nil)
  end

  it "should perform a successful query if the ISBN is provided as a number" do
    # Mock TCPSocket to return a valid response with no matching titles
    data = File.read(File.dirname(__FILE__) + "/responses/single_result.txt").strip
    socket = TCPSocket.stub_instance(:print => true, :close => true, :gets => data)
    TCPSocket.stub_method(:new => socket)

    pos = GBIP::POS.new(@username, @password)
    result = pos.find(:first, @isbn13.to_i)
    result.should be_a_kind_of(GBIP::Title)
  end

  it "should raise an exception if no reponse is received in a certain amount of time" do
    # Mock TCPSocket to take 5 seconds to generate a response
    socket = TCPSocket.stub_instance(:print => true, :close => true)
    socket.stub_method(:gets) do
      sleep 5
    end
    TCPSocket.stub_method(:new => socket)

    pos = GBIP::POS.new(@username, @password)
    lambda { pos.find(:first, @isbn13, :timeout => 2) }.should raise_error(Timeout::Error)
  end

  #####################
  #  :all searches
  #####################
  it "should return a non-empty Array when queried for a single valid ISBN10" do
    # Mock TCPSocket to return a valid response with a single result 
    data = File.read(File.dirname(__FILE__) + "/responses/single_result.txt").strip
    socket = TCPSocket.stub_instance(:print => true, :close => true, :gets => data)
    TCPSocket.stub_method(:new => socket)

    pos = GBIP::POS.new(@username, @password)
    result = pos.find(:all, @isbn10)
    result.should be_a_kind_of(Array)
    result.should_not be_empty
  end

  it "should return a non-empty Array when queried for a single valid ISBN13" do
    # Mock TCPSocket to return a valid response with a single result 
    data = File.read(File.dirname(__FILE__) + "/responses/single_result.txt").strip
    socket = TCPSocket.stub_instance(:print => true, :close => true, :gets => data)
    TCPSocket.stub_method(:new => socket)

    pos = GBIP::POS.new(@valid_username, @valid_password)
    result = pos.find(:all, @isbn13)
    result.should be_a_kind_of(Array)
    result.should_not be_empty
  end

  it "should return an empty Array when a single ISBN10 not recognised by GBIP is requested" do
    # Mock TCPSocket to return a valid response with no matches
    data = File.read(File.dirname(__FILE__) + "/responses/no_result.txt").strip
    socket = TCPSocket.stub_instance(:print => true, :close => true, :gets => data)
    TCPSocket.stub_method(:new => socket)

    pos = GBIP::POS.new(@username, @password)
    result = pos.find(:all, @isbn10)
    result.should be_a_kind_of(Array)
    result.should be_empty
  end

  it "should return an empty Array when a single ISBN13 not recognised by GBIP is requested" do
    # Mock TCPSocket to return a valid response with no matches
    data = File.read(File.dirname(__FILE__) + "/responses/no_result.txt").strip
    socket = TCPSocket.stub_instance(:print => true, :close => true, :gets => data)
    TCPSocket.stub_method(:new => socket)

    pos = GBIP::POS.new(@username, @password)
    result = pos.find(:all, @isbn13)
    result.should be_a_kind_of(Array)
    result.should be_empty
  end

  it "should return an Array with multiple items when a query returns multiple matches" do
    # Mock TCPSocket to return a valid response with no matches
    data = File.read(File.dirname(__FILE__) + "/responses/multiple_response.txt").strip
    socket = TCPSocket.stub_instance(:print => true, :close => true, :gets => data)
    TCPSocket.stub_method(:new => socket)

    pos = GBIP::POS.new(@username, @password)
    result = pos.find(:all, @isbn13)
    result.should be_a_kind_of(Array)
    result.size.should eql(3)
  end

  it "should return an empty array when any object is supplied as an ISBN when searching for :all" do
    pos = GBIP::POS.new(@username, @password)
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

  it "should perform a successful query if the ISBN is provided as a number to an :all search" do
    # Mock TCPSocket to return a valid response with a single result 
    data = File.read(File.dirname(__FILE__) + "/responses/single_result.txt").strip
    socket = TCPSocket.stub_instance(:print => true, :close => true, :gets => data)
    TCPSocket.stub_method(:new => socket)

    pos = GBIP::POS.new(@username, @password)
    result = pos.find(:all, @isbn13.to_i)
    result.should be_a_kind_of(Array)
    result.should_not be_empty
  end

  #####################
  #  invalid searches
  #####################
  it "should raise an exception when an invalid search type is supplied" do
    pos = GBIP::POS.new(@username, @password)
    lambda { pos.find(nil, @isbn10) }.should raise_error(ArgumentError)
    lambda { pos.find(:last, @isbn10) }.should raise_error(ArgumentError)
    lambda { pos.find(123456, @isbn10) }.should raise_error(ArgumentError)
  end

end
