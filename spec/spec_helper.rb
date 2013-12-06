ENV['RACK_ENV'] = 'test'

require 'rack/test'
require 'rack'
require 'rack-protection'
require 'rspec'
require 'rspec-html-matchers'
require './app.rb'

def app
  Sinatra::Application
end
