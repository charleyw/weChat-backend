ENV['RACK_ENV'] = 'test'

require 'rack/test'
require 'rack'
require 'rack-protection'
require 'rspec'
require 'rspec-html-matchers'
require './app.rb'

TEXT_MESSAGE_REQUEST='<xml><ToUserName><![CDATA[toUser]]></ToUserName><FromUserName><![CDATA[fromUser]]></FromUserName><CreateTime>1348831860</CreateTime><MsgType><![CDATA[text]]></MsgType><Content><![CDATA[this is a test]]></Content><MsgId>1234567890123456</MsgId></xml>'

EVENT_MESSAGE_REQUEST='<xml>
                        <ToUserName><![CDATA[toUser]]></ToUserName>
                        <FromUserName><![CDATA[fromUser]]></FromUserName>
                        <CreateTime>123456789</CreateTime>
                        <MsgType><![CDATA[event]]></MsgType>
                        <Event><![CDATA[subscribe]]></Event>
                        </xml>'


def app
  Sinatra::Application
end
