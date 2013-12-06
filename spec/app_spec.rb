require_relative 'spec_helper'
describe 'app' do
  include Rack::Test::Methods

  TEXT_MESSAGE_REQUEST='<xml>
                        <ToUserName><![CDATA[toUser]]></ToUserName>
                        <FromUserName><![CDATA[fromUser]]></FromUserName>
                        <CreateTime>1348831860</CreateTime>
                        <MsgType><![CDATA[text]]></MsgType>
                        <Content><![CDATA[this is a test]]></Content>
                        <MsgId>1234567890123456</MsgId>
                      </xml>'

  it 'should echo string when request with echostr parameter' do
    get '/?echostr=test'
    last_response.body.should include 'test'
  end

  it 'should echo text request message when receive a text request message' do
    WeiXinRequestHandler.any_instance.should_receive(:on_text_message).with('this is a test'){'results'}
    post '/', TEXT_MESSAGE_REQUEST, 'CONTENT_TYPE' => 'text/xml'
    last_response.body.should include '<ToUserName><![CDATA[fromUser]]></ToUserName>'
    last_response.body.should include '<Content><![CDATA[results]]></Content>'
  end
end
