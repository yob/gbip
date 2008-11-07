class MockTCPSocket

  def initialize(host,port)
    # do nothing
  end

  def print(query)
    query = query.to_s.split("\t")
    @username = query[3]
    @password = query[4]
    m, @isbn = *query[7].match(/bn=(\d\d\d\d\d\d\d\d\d\d\d\d\d)/)
  end

  def gets(placeholder)

    # if the requested isbn isn't an isbn10
    unless RBook::ISBN.valid_isbn13?(@isbn)
      return File.read(File.dirname(__FILE__) + "/responses/no_result.txt").strip
    end

    # if the isbn10 is one we have available
    if @isbn.eql?("9781741146714")
      return File.read(File.dirname(__FILE__) + "/responses/single_result.txt").strip
    elsif @isbn.eql?("9781590599358")
      return File.read(File.dirname(__FILE__) + "/responses/single_result2.txt").strip
    elsif @isbn.eql?("9780732282721")
      return File.read(File.dirname(__FILE__) + "/responses/no_warehouses.txt").strip
    else
      return File.read(File.dirname(__FILE__) + "/responses/no_result.txt").strip
    end
    @username = nil
    @password = nil
    isbn = nil
  end

  def close

  end
end
