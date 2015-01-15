require 'pry'
require 'redis'
require 'sinatra/base'
require 'sinatra/reloader'
require 'httparty'

require_relative 'server'

run Review::Server
