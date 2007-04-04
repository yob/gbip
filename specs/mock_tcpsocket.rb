class MockTCPSocket

  def initialize(host,port)
    # do nothing
  end

  def print(query)
    query = query.to_s.split("\t")
    @username = query[3]
    @password = query[4]
    m, @isbn = *query[7].match(/bn=(\d\d\d\d\d\d\d\d\d[\dXx])/)
  end

  def gets(placeholder)
   
    # if incorrect login details are supplied
    unless @username.eql?("user") && @password.eql?("pass")
     return File.read(File.dirname(__FILE__) + "/responses/invalid_login.txt").strip
    end

    # if the requested isbn isn't an isbn10
    unless RBook::ISBN.valid_isbn10?(@isbn)
      return File.read(File.dirname(__FILE__) + "/responses/no_result.txt").strip
    end

    # if the isbn10 is one we have available
    if @isbn.eql?("1741146712")
      return File.read(File.dirname(__FILE__) + "/responses/single_result.txt").strip
    else
      return File.read(File.dirname(__FILE__) + "/responses/no_result.txt").strip
    end
    @username = nil
    @password = nil
    @isbn = nil
  end

  def close

  end
end
