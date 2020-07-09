require "net/http"
require "json"
require 'boolean'

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
  
    def setClientProtocol(protocol = "http")
      @@protocol = protocol
    end
    
    def setClientAPIVersion(api_v = "1.0")
      @@api_v = api_v
    end
  
    def apiQuery(query_method = "getSystemInfo", qparams = {})
      query_array = {method: query_method, token: @token, params: qparams}
      
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
      rescue Errno::ECONNREFUSED
        return ""
      end

      return response.body
    end

    def getSystemInfo
      return parseResult(apiQuery())
    end
    
    def parseResult(result = {}, byDefault = {})
      if result == ""
        return byDefault
      end
      parsed = JSON.parse(result)
      if parsed.include? "result" == false
        return byDefault
      end
      return parsed["result"]
    end
    
    def connected?
      if getSystemInfo() == {}
        return false
      else
        return true
      end
    end
    
    def getProfileStatus
      return parseResult(apiQuery("getProfileStatus"))
    end
    
    def setProfileStatus(status = "Available", mood = "")
      params = {status: status, mood: mood}
      result = parseResult(
        apiQuery("setProfileStatus", params),
        false
      )
      if result.is_a?(Boolean) == false
        return false
      end
      return true
    end
  end
end
