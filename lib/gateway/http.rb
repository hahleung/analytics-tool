module Gateway
  class Http
    PER_PAGE = 10000

    private_class_method :new

    def self.get(url)
      new.get(url)
    end

    def get(url)
      query_string = "?per_page=#{PER_PAGE}&page=#{@page}"
      body = JSON.parse(http_call(url + query_string))
      data = body.fetch("data")
      @data = @data + data

      return @data if data.size < PER_PAGE
      @page += 1 
      get(url)
    end

    def http_call(url)
      RestClient.get(url)
    end
    
    private

    def initialize
      @data = []
      @page = 1
    end
  end
end