require 'socket'
require 'enumerator'

module RBook

  module GBIP

    # Provides easy access to the globalbooksinprint.com search API.
    # RBook::GBIP has basic usage examples.
    class POS
    
      # don't think we really need these
      #attr_accessor :username, :password

      POS_SERVER = "pos.bowker.com"
      POS_PORT = 7052

      # creates a new POS object ready to perform a search
      def initialize(username, password, socket_class = nil)
        @username = username
        @password = password
        @socket_class = socket_class || TCPSocket
      end

      # search for the specified ISBN on globalbooksinprint.com.
      # Accepts both ISBN10 and ISBN13's.
      def find(type, isbn, options = {})
        case type
          when :first then default_return = nil
          when :all then default_return = []
          else raise ArgumentError, 'type must by :first or :all'
        end
        #unless [:first, :all].include?(type)
        #  raise ArgumentError, 'type must by :first or :all'
        #end

        # global only accepts ISBNs as 10 digits at this stage
        isbn = RBook::ISBN.convert_to_isbn10(isbn.to_s)
        return default_return if isbn.nil?
        
        request_format = "POS"
        account_type = "3"
        product = "2"
        username = "#{@username}"
        password = "#{@password}"
        version = "2"
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

        gbip = @socket_class.new(POS_SERVER, POS_PORT)
        gbip.print request_string
        response = gbip.gets(nil).split("#")
        gbip.close
        
        header = nil
        titles_arr = []
        response.each do |arr|
          if header.nil?
            header = arr.split("\t")
          else
            titles_arr << arr.split("\t")
            titles_arr[-1] = titles_arr.last[1,titles_arr.last.size-1]
          end
        end
        
        # raise an exception if incorrect login details were provided
        if header.first.eql?("66") 
          raise RBook::InvalidLoginError, "Invalid username or password"
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
        return nil if arr.size < 15

        title_arr = arr[0, 15]
        title = Title.new(title_arr)

        if title_arr.last.to_i > 0
          warehouse_arr = arr[15,arr.size - 15]
          warehouse_arr.each_slice(5) do |slice|
            warehouse_obj = Warehouse.new(slice)
            title.warehouses << warehouse_obj unless warehouse_obj.nil?
          end
        end

        return title
      end
    end

  end

end
