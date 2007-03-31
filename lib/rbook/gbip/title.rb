require 'bigdecimal'

module RBook
  module GBIP

    # models a warehouse supply detail from the Global Books in Print API 
    class Title


      attr_accessor :market, :title, :isbn, :binding, :status, :edition
      attr_accessor :contributor, :publisher, :publication_date
      attr_accessor :rrp, :supplier, :suppliers_with_stock
      attr_accessor :warehouses

      def initialize(arr)
        raise ArgumentError, "arr must be an array" unless arr.class == Array
        #raise ArgumentError, "Invalid number of array elements" unless arr.size == 14

        self.market = arr[2].strip
        self.title = arr[3].strip
        self.isbn = RBook::ISBN.convert_to_isbn13(arr[4].strip) || arr[4].strip
        self.binding = arr[5].strip
        self.status = arr[6].strip
        self.edition = arr[7].strip
        self.contributor = arr[8].strip
        self.publisher = arr[9].strip
        self.publication_date = arr[10].strip
        self.rrp = BigDecimal.new(arr[11].strip)
        self.supplier = arr[12].strip
        self.suppliers_with_stock = arr[13].strip

        @warehouses = []
      end
    end
  end
end
