require_relative 'spec_helper'
describe 'app' do
  include Rack::Test::Methods

  it 'should echo string when request with echostr parameter' do
    get '/?echostr=test'
    last_response.body.should include 'test'
  end

  it 'should return user defined text message when receive a text request message' do
    WeiBackend::MessageDispatcher.on_text do
      'hello world'
    end

    post '/', TEXT_MESSAGE_REQUEST, 'CONTENT_TYPE' => 'text/xml'
    last_response.body.should include '<ToUserName><![CDATA[fromUser]]></ToUserName>'
    last_response.body.should include '<Content><![CDATA[hello world]]></Content>'
  end

  it 'should return user defined news message when receive a text request message' do
    WeiBackend::MessageDispatcher.on_text do
      {:title => 'title', :description => 'desc', :picture_url => 'pic url', :url => 'url'}
    end

    post '/', TEXT_MESSAGE_REQUEST, 'CONTENT_TYPE' => 'text/xml'
    last_response.body.should include '<ToUserName><![CDATA[fromUser]]></ToUserName>'
    last_response.body.should include '<Title><![CDATA[title]]></Title>'
  end

  it 'should return news message when receive a text request message and user defined a multi-news' do
    WeiBackend::MessageDispatcher.on_text do
      [{:title => 'title', :description => 'desc', :picture_url => 'pic url', :url => 'url'},
      {:title => 'title1', :description => 'desc1', :picture_url => 'pic url1', :url => 'url1'}]
    end

    post '/', TEXT_MESSAGE_REQUEST, 'CONTENT_TYPE' => 'text/xml'
    last_response.body.should include '<ToUserName><![CDATA[fromUser]]></ToUserName>'
    last_response.body.should include '<Title><![CDATA[title]]></Title>'
    last_response.body.should include '<Title><![CDATA[title1]]></Title>'
  end

  it 'should echo event request message when receive a event message' do
    WeiBackend::MessageDispatcher.on_event do
      'hello event'
    end

    post '/', EVENT_MESSAGE_REQUEST, 'CONTENT_TYPE' => 'text/xml'
    last_response.body.should include '<ToUserName><![CDATA[fromUser]]></ToUserName>'
    last_response.body.should include '<Content><![CDATA[hello event]]></Content>'
  end

end
