require "net/http"
require "json"
require 'boolean'

module UtopiaRuby
  class QueryFilter
    @@sortBy = ""
    @@offset = ""
    @@limit  = ""
    
    def initialize(sortBy = "", offset = "", limit = "")
      @@sortBy = sortBy
      @@offset = offset
      @@limit  = limit
    end
  end

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
  
    def apiQuery(query_method = "getSystemInfo", qparams = {}, query_filter = nil)
      query_array = {method: query_method, token: @token, params: qparams}
      if query_filter != nil
        query_array["filter"] = query_filter
      end
      
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
    
    def parseBool(value = false)
      if value.is_a?(Boolean) == false
        return false
      end
      return true
    end
    
    def parseInt(value)
      if !(value >= 0)
        return 0
      end
      return value
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
      return parseBool(result)
    end
    
    def getOwnContact
      return parseResult(apiQuery("getOwnContact"))
    end
    
    def getContacts(searchFilter = "", query_filter = nil)
      params = {filter: searchFilter}
      return parseResult(apiQuery("getContacts", params, query_filter))
    end
    
    def getContactAvatar(pk = "", coder = "BASE64", format = "PNG")
      params = {
        pk: pk,
        coder: coder,
        format: format
      }
      return parseResult(apiQuery("getContactAvatar", params), "")
    end
    
    def getChannelAvatar(channelid = "", coder = "BASE64", format = "PNG")
      params = {
        channelid: channelid,
        coder: coder,
        format: format
      }
      return parseResult(apiQuery("getChannelAvatar", params), "")
    end
    
    def setContactGroup(pk = "", groupName = "group")
      params = {contactPublicKey: pk, groupName: groupName}
      result = parseResult(
        apiQuery("setContactGroup", params),
        false
      )
      return parseBool(result)
    end
    
    def setContactNick(pk = "", newNick = "user")
      params = {contactPublicKey: pk, newNick: newNick}
      result = parseResult(
        apiQuery("setContactNick", params),
        false
      )
      return parseBool(result)
    end
    
    def sendInstantMessage(pkOrNick = "", message = "test message")
      params = {to: pkOrNick, text: message}
      result = parseResult(
        apiQuery("sendInstantMessage", params),
        0
      )
      return parseInt(result)
    end
    
    def sendInstantQuote(pkOrNick = "", text = "instant quoute", id_message = 100)
      params = {
        to: pkOrNick,
        text: text,
        id_message: id_message
      }
      result = parseResult(
        apiQuery("sendInstantQuote", params),
        0
      )
      return parseInt(result)
    end
    
    def sendInstantSticker(pkOrNick = "", collection = "434", name = "343")
      params = {to: pkOrNick, collection: collection, name: name}
      result = parseResult(
        apiQuery("sendInstantSticker", params),
        0
      )
      return parseInt(result)
    end
    
    def getStickerCollections
      return parseResult(apiQuery("getStickerCollections"))
    end
    
    def getImageSticker(collection = "Default Stickers", stickerName = "airship", coder = "BASE64")
      params = {collection_name: collection, sticker_name: stickerName, coder: coder}
      return parseResult(apiQuery("getImageSticker", params), "")
    end
    
    def sendInstantBuzz(pkOrNick = "", comments = "test")
      params = {to: pkOrNick, comments: comments}
      result = parseResult(
        apiQuery("sendInstantBuzz", params),
        0
      )
      return parseInt(result)
    end
    
    def sendInstantInvitation(pkOrNick = "", channelid = "", description = "", comments = "")
      params = {to: pkOrNick, channelid: channelid, description: description, comments: comments}
      result = parseResult(
        apiQuery("sendInstantInvitation", params),
        0
      )
      return parseInt(result)
    end
    
    def removeInstantMessages(pk = "")
      params = {hex_contact_public_key: pk}
      result = parseResult(apiQuery("removeInstantMessages", params), false)
      return parseBool(result)
    end
    
    def getContactMessages(pk = "", query_filter = nil)
      params = {pk: pk}
      return parseResult(apiQuery("getContactMessages", params, query_filter))
    end
    
    def sendEmailMessage(pkOrNick = "", subject = "test message", body = "message content")
      params = {to: [pkOrNick], subject: subject, body: body}
      result = parseResult(apiQuery("sendEmailMessage", params))
      return parseBool(result)
    end
    
  end
end
