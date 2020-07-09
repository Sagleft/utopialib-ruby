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

puts "check client availability.."
if client.connected?
  puts "client connected"; puts ""
  
  puts "call the GetSystemInfo method.."; puts ""
  puts client.getSystemInfo
else
  puts "Something went wrong. failed to connect to client"
end
