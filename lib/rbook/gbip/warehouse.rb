require 'date'

module RBook
  module GBIP

    # models a warehouse supply detail from the Global Books in Print API 
    class Warehouse


      attr_accessor :name, :status, :onhand, :onorder, :updated_at 

      def initialize(arr)
        raise ArgumentError, "arr must be an array" unless arr.class == Array
        raise ArgumentError, "Invalid number of array elements" unless arr.size == 5

        self.name = arr[0].strip
        self.status = arr[1].strip
        self.onhand = arr[2].to_i
        self.onorder = arr[3].to_i
        tmpdate = arr[4]
        self.updated_at = Date.civil(tmpdate[6,4].to_i, tmpdate[0,2].to_i, tmpdate[3,2].to_i)
      end
    end
  end
end
