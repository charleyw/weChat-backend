require_relative 'spec_helper'
describe 'app' do
  include Rack::Test::Methods

  it 'should echo string when request with echostr parameter' do
    get '/weixin?echostr=test'
    last_response.body.should include 'test'
  end

  it 'should return user defined text message when receive a text request message' do
    WeiBackend::MessageDispatcher.on_text do
      'hello world'
    end

    post '/weixin', TEXT_MESSAGE_REQUEST, 'CONTENT_TYPE' => 'text/xml'
    last_response.body.should include '<ToUserName><![CDATA[fromUser]]></ToUserName>'
    last_response.body.should include '<Content><![CDATA[hello world]]></Content>'
  end

  it 'should return user defined news message when receive a text request message' do
    WeiBackend::MessageDispatcher.on_text do
      {:title => 'title', :description => 'desc', :picture_url => 'pic url', :url => 'article url'}
    end

    post '/weixin', TEXT_MESSAGE_REQUEST, 'CONTENT_TYPE' => 'text/xml'
    last_response.body.should include '<ToUserName><![CDATA[fromUser]]></ToUserName>'
    last_response.body.should include '<Url><![CDATA[article url]]></Url>'
  end

  it 'should return user defined music message when receive a text request message' do
    WeiBackend::MessageDispatcher.on_text do
      {:title => 'title', :description => 'desc', :music_url => 'url', :hd_music_url => 'hd music url'}
    end

    post '/weixin', TEXT_MESSAGE_REQUEST, 'CONTENT_TYPE' => 'text/xml'
    last_response.body.should include '<ToUserName><![CDATA[fromUser]]></ToUserName>'
    last_response.body.should include '<MusicUrl><![CDATA[url]]></MusicUrl>'
  end

  it 'should return news message when receive a text request message and user defined a multi-news' do
    WeiBackend::MessageDispatcher.on_text do
          [{
               :title => 'title',
               :description => 'desc',
               :picture_url => 'pic url',
               :url => 'url'
           },
           {
               :title => 'title1',
               :description => 'desc1',
               :picture_url => 'pic url1',
               :url => 'url1'
           }]
    end

    post '/weixin', TEXT_MESSAGE_REQUEST, 'CONTENT_TYPE' => 'text/xml'
    last_response.body.should include '<ToUserName><![CDATA[fromUser]]></ToUserName>'
    last_response.body.should include '<Title><![CDATA[title]]></Title>'
    last_response.body.should include '<Title><![CDATA[title1]]></Title>'
    last_response.body.should include '<Url><![CDATA[url]]></Url>'
    last_response.body.should include '<Url><![CDATA[url1]]></Url>'
  end

  it 'should echo location message when receive a location event message' do
    WeiBackend::MessageDispatcher.on_location do
      "location event: #{params[:Latitude]}"
    end

    post '/weixin', LOCATION_EVENT_REQUEST, 'CONTENT_TYPE' => 'text/xml'
    last_response.body.should include '<ToUserName><![CDATA[fromUser]]></ToUserName>'
    last_response.body.should include '<Content><![CDATA[location event: 23.137466]]></Content>'
  end

  it 'should echo location message when receive a location event message' do
    WeiBackend::MessageDispatcher.on_subscribe do
      'Thank you for subscribe!'
    end

    post '/weixin', SUBSCRIBE_EVENT_REQUEST, 'CONTENT_TYPE' => 'text/xml'
    last_response.body.should include '<ToUserName><![CDATA[fromUser]]></ToUserName>'
    last_response.body.should include '<Content><![CDATA[Thank you for subscribe!]]></Content>'
  end

  it 'should do something when user have set token' do
    WeiBackend::MessageDispatcher.on_subscribe do
      'Thank you for subscribe!'
    end

    WeiBackend::MessageDispatcher.token 'combustest'

    post '/weixin?signature=0d144fa22f4119dbb2f6fe9710f3b732fb45092b&timestamp=1388674716&nonce=1388564676', SUBSCRIBE_EVENT_REQUEST, 'CONTENT_TYPE' => 'text/xml'
    last_response.body.should include '<ToUserName><![CDATA[fromUser]]></ToUserName>'
    last_response.body.should include '<Content><![CDATA[Thank you for subscribe!]]></Content>'
  end

end
