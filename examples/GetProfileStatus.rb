require 'rubygems'
require 'dotenv'

begin
  #load credentials from environment
  Dotenv.load('./../.env')
  host  = ENV["UTOPIA_HOST"]
  port  = ENV["UTOPIA_PORT"]
  token = ENV["UTOPIA_TOKEN"]
end

#load library code (dev)
load './../lib/utopialib.rb'
client = UtopiaRuby::Client.new(host, token, port)

puts client.getProfileStatus
