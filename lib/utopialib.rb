require "net/http"
require "json"

module UtopiaRuby
  class Client
    @@protocol = "http"
    @@api_v = "1.0"
    @host  = "127.0.0.1"
    @token = ""
    @port  = 22820

    def initialize(host = "127.0.0.1", token = "", port = 22820)
      @host  = host
      @token = token
      @port  = port
    end
  
    def SetClientProtocol(protocol = "http")
      @@protocol = protocol
    end
    
    def SetClientAPIVersion(api_v = "1.0")
      @@api_v = api_v
    end
  
    def ApiQuery(query_method = "GetSystemInfo")
      query_array = {method: query_method, token: @token, params: nil}
      
      #puts @host #debug
      #return "" #debug
      endpoint = @@protocol + "://" + @host + ":" + @port.to_s + "/api/" + @@api_v + "/"
      #puts endpoint #debug

      begin
        uri = URI.parse(endpoint)
        header = {"Content-Type": "text/json"}
        http = Net::HTTP.new(uri.host, uri.port)
        request = Net::HTTP::Post.new(uri.request_uri, header)
        request.body = query_array.to_json
        response = http.request(request)
      rescue SocketError
        #puts "SocketError"
        return ""
      end

      return response.body
    end

    def GetSystemInfo
      result = ApiQuery()
      if result == ""
        return {}
      end
      return JSON.parse(result)
    end
  end
end
