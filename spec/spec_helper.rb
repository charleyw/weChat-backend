ENV['RACK_ENV'] = 'test'

require 'rack/test'
require 'rack'
require 'rack-protection'
require 'rspec'
require 'rspec-html-matchers'
require './lib/wei-backend'

TEXT_MESSAGE_REQUEST='<xml><ToUserName><![CDATA[toUser]]></ToUserName><FromUserName>'+
    '<![CDATA[fromUser]]></FromUserName><CreateTime>1348831860</CreateTime><MsgType><![CDATA[text]]></MsgType>'+
    '<Content><![CDATA[this is a test]]></Content><MsgId>1234567890123456</MsgId></xml>'

EVENT_MESSAGE_REQUEST='<xml><ToUserName><![CDATA[toUser]]></ToUserName>'+
    '<FromUserName><![CDATA[fromUser]]></FromUserName><CreateTime>123456789</CreateTime>'+
    '<MsgType><![CDATA[event]]></MsgType><Event><![CDATA[subscribe]]></Event></xml>'

LOCATION_EVENT_REQUEST='<xml>
	<ToUserName><![CDATA[toUser]]></ToUserName>
	<FromUserName><![CDATA[fromUser]]></FromUserName>
	<CreateTime>123456789</CreateTime>
	<MsgType><![CDATA[event]]></MsgType>
	<Event><![CDATA[LOCATION]]></Event>
	<Latitude>23.137466</Latitude>
	<Longitude>113.352425</Longitude>
	<Precision>119.385040</Precision>
</xml>'

SUBSCRIBE_EVENT_REQUEST='<xml>
	<ToUserName><![CDATA[toUser]]></ToUserName>
	<FromUserName><![CDATA[fromUser]]></FromUserName>
	<CreateTime>123456789</CreateTime>
	<MsgType><![CDATA[event]]></MsgType>
	<Event><![CDATA[subscribe]]></Event>
</xml>'

PARSED_PARAMS={
    :ToUserName => 'toUser',
    :FromUserName => 'fromUser',
    :CreateTime => '1348831860',
    :MsgType => 'text',
    :Content => 'this is a test',
    :MsgId => '1234567890123456'
}

def app
  Sinatra::Application
end
