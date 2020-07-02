require 'net/http'
require 'json'

module UtopiaRuby
  class Client
    @protocol = "http"
    @host  = "127.0.0.1"
    @token = ""
    @port  = 22820
    @api_v = "1.0"

    def initialize(host = "127.0.0.1", token = "", port = 22820)
      @host  = host
      @token = token
      @port  = port
    end
  
    def self.ApiQuery(query_method = "GetSystemInfo")
      query_array = {method: query_method, token: @token, params: nil}
      query_json  = query_array.to_json
      endpoint = @protocol + "://" + @host + ":" + port.to_s + "/api/" + @api_v + "/"

      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Post.new(uri.path, 'Content-Type' => 'application/json')
      request.body = query_json
      result = http.request(req)
  
      #json response
      return result.body
    end
  
    def GetSystemInfo
      return JSON.parse(ApiQuery())
    end
  end
end
