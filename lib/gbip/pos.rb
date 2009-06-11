require 'socket'
require 'enumerator'
require 'timeout'

module GBIP

  # Provides easy access to the globalbooksinprint.com search API.
  # RBook::GBIP has basic usage examples.
  class POS

    # don't think we really need these
    #attr_accessor :username, :password

    POS_SERVER = "pos.bowker.com"
    POS_PORT = 7052

    # creates a new POS object ready to perform a search
    def initialize(username, password)
      @username = username
      @password = password
    end

    # search for the specified ISBN on globalbooksinprint.com.
    # Accepts both ISBN10 and ISBN13's.
    #
    # Supported options:
    # :markets => only search the specified markets. comma sperated list
    # :timeout => amount of time in seconds to wait for a reponse from the server before timing out. Defaults to 10.
    #
    def find(type, isbn, options = {})
      case type
      when :first then default_return = nil
      when :all then default_return = []
      else raise ArgumentError, 'type must by :first or :all'
      end

      options = {:timeout => 10}.merge(options)

      isbn = RBook::ISBN.convert_to_isbn13(isbn.to_s) || isbn.to_s
      return default_return unless RBook::ISBN.valid_isbn13?(isbn)

      request_format = "POS"
      account_type = "3"
      product = "2"
      username = "#{@username}"
      password = "#{@password}"
      version = "3"
      supplier = ""
      request = "bn=#{isbn}"
      filters = "1|1|1|1|1|1|1|1|1|1"
      if type.eql?(:first)
        records = "1,0"
      else
        records = "10,0"
      end
      sort_order = "1"
      markets = options[:markets] || ""

      request_string = "#{request_format}\t#{account_type}\t#{product}\t#{username}\t#{password}\t"
      request_string << "#{version}\t#{supplier}\t#{request}\t#{filters}\t#{records}\t#{sort_order}\t"
      request_string << "#{markets}\t"

      sock = TCPSocket.new(POS_SERVER, POS_PORT)
      sock.print request_string
      response = Timeout::timeout(options[:timeout]) { sock.gets(nil) }
      sock.close

      # error handling
      case response.to_s[0,1]
      when "5"
        raise GBIP::InvalidRequestError, "Unknown Account Type or Request Version"
      when "6"
        raise GBIP::InvalidLoginError, "Invalid username or password"
      when "7"
        raise GBIP::InvalidRequestError, "Bad Data"
      when "8"
        raise GBIP::InvalidRequestError, "Invalid Request Version"
      when "9"
        raise GBIP::SystemUnavailableError, "System Unavailable"
      end

      # split the response into header/body
      idx = response.index("#")
      if idx.nil?
        header = response.split("\t")
      else
        header = response[0, idx - 1]
        body   = response[idx, response.size - idx].split("\t")
        body.shift
      end

      titles_arr = []
      while body.size > 0
        warehouse_count = body[21].to_i
        extract_count = 22 + (5 * warehouse_count)
        titles_arr << body.slice!(0, extract_count)
      end

      if titles_arr.size == 0
        # return nil if no matching records found
        return nil
      else

        titles = []
        titles_arr.each do |arr|
          title = build_object_tree(arr)
          titles << title unless title.nil?
        end

        if type.eql?(:first)
          return titles.first
        else
          return titles
        end
      end

    end

    private

    def build_object_tree(arr)
      raise ArgumentError, 'arr must be an array' unless arr.class == Array
      return nil if arr.size < 22

      title_arr = arr[0, 22]
      title = GBIP::Title.new(title_arr)

      if title_arr.last.to_i > 0
        warehouse_arr = arr[22,arr.size - 22]
        warehouse_arr.each_slice(5) do |slice|
          warehouse_obj = GBIP::Warehouse.new(slice)
          title.warehouses << warehouse_obj unless warehouse_obj.nil?
        end
      end

      return title
    end
  end

end
