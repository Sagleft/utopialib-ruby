require 'rubygems'
require 'dotenv/load'

load './lib/utopialib.rb'

#load credentials from environment
host  = ENV["UTOPIA_HOST"]
port  = ENV["UTOPIA_PORT"]
token = ENV["UTOPIA_TOKEN"]

client = UtopiaRuby::Client.new(host, token, port)
puts client.GetSystemInfo
