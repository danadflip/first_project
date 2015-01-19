require 'sinatra/namespace'
require 'sinatra/base'
require 'sinatra/reloader'
require 'rest_client'
require 'redis'
require 'uri'
require 'pry'
require 'httparty'

require_relative 'server'

run Review::Server


