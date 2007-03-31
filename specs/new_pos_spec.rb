$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../lib')

require 'rbook/gbip'
include RBook

context "A new POS object" do

  setup do
    @valid_username = "user"
    @valid_password = "pass"
    @valid_isbn10 = "0571228526"
    @valid_isbn13 = "9780571228522"
    
    @fail_auth_socket = mock("TCPSocket") 
    @fail_auth_socket.should_receive(:new).with(:string, :numeric).and_return(@fail_auth_socket)
    @fail_auth_socket.should_receive(:print).with(:string)
    @fail_auth_socket.should_receive(:gets).with(:anything).and_return("66")
    @fail_auth_socket.should_receive(:close).with(:no_args)
    
  end

  specify "should raise an exceptin when an invalid username or password is supplied" do
    pos = GBIP::POS.new(@valid_username, @valid_password, @fail_auth_socket)
    lambda { pos.find(:first, @valid_isbn10) }.should_raise_error(RBook::InvalidLoginError)
  end

  #specify "Should be able to find a valid title by it's ISBN10" do
    #pos = GBIP::POS.new(@valid_username, @valid_password, @socket)
    #result = pos.find(:first, @valid_isbn10)
    #result.should_be_a(RBook::GBIP::Title)
  #end

  #specify "Should be able to find a valid title by it's ISBN13" do
    #result = @pos.find(:first, @valid_isbn13)
    #result.should_be_a(RBook::GBIP::Title)
  #end

end
