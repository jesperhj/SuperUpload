require 'rubygems'
require "bundler/setup"
require "json"
require 'pp'

ENV["RACK_ENV"] = 'development' unless defined?(ENV["RACK_ENV"])
Bundler.setup(:default, ENV["RACK_ENV"]).require(:default, ENV["RACK_ENV"])

# Load Sinatra app
require 'uploader'