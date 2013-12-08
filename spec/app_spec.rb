require_relative 'spec_helper'
describe 'app' do
  include Rack::Test::Methods

  it 'should echo string when request with echostr parameter' do
    get '/?echostr=test'
    last_response.body.should include 'test'
  end

  it 'should echo text request message when receive a text request message' do
    WeiBackend::MessageDispatcher.any_instance.should_receive(:handle_text_message){'results'}
    post '/', TEXT_MESSAGE_REQUEST, 'CONTENT_TYPE' => 'text/xml'
    last_response.body.should include '<ToUserName><![CDATA[fromUser]]></ToUserName>'
    last_response.body.should include '<Content><![CDATA[results]]></Content>'
  end

  it 'should echo event request message when receive a event message' do
    WeiBackend::MessageDispatcher.any_instance.should_receive(:handle_event_message){'results'}
    post '/', EVENT_MESSAGE_REQUEST, 'CONTENT_TYPE' => 'text/xml'
    last_response.body.should include '<ToUserName><![CDATA[fromUser]]></ToUserName>'
    last_response.body.should include '<Content><![CDATA[results]]></Content>'
  end

end
