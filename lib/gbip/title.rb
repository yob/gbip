require 'bigdecimal'
require 'yaml'

module GBIP

  # models a warehouse supply detail from the Global Books in Print API 
  class Title


    attr_accessor :market, :title, :isbn, :binding, :status, :edition
    attr_accessor :contributor, :publisher, :publication_date
    attr_accessor :rrp, :supplier, :suppliers_with_stock
    attr_accessor :country, :pubcode, :currency, :bowker_subject
    attr_accessor :bisac_subject, :child_subject, :bic_subject
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
      self.country = arr[12].strip
      self.pubcode = arr[13].strip
      self.currency = arr[14].strip
      self.bowker_subject = arr[15].strip
      self.bisac_subject = arr[16].strip
      self.child_subject = arr[17].strip
      self.bic_subject = arr[18].strip
      self.supplier = arr[19].strip
      self.suppliers_with_stock = arr[20].strip

      @warehouses = []
    end

    def to_hash
      {
       :status    => self.status,
       :pubdate   => self.publication_date,
       :binding   => self.binding,
       :publisher => self.publisher,
       :contributor => self.contributor,
       :isbn      => self.isbn,
       :edition   => self.edition,
       :market    => self.market,
       :rrp       => self.rrp.to_s("F"),
       :title     => self.title,
       :country   => self.country,
       :pubcode   => self.pubcode,
       :currency  => self.currency,
       :bowker_subject => self.bowker_subject,
       :bisac_subject  => self.bisac_subject,
       :child_subject  => self.child_subject,
       :bic_subject    => self.bic_subject,
       :supplier  => self.supplier,
       :suppliers_with_stock => self.suppliers_with_stock
      }
    end

    def to_yaml
      YAML.dump(to_hash)
    end
  end
end
