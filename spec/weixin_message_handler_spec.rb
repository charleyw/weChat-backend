require_relative 'spec_helper'
require_relative '../lib/wei_xin_message_dispatcher'

PARSED_PARAMS={
    :ToUserName => 'toUser',
    :FromUserName => 'fromUser',
    :CreateTime => '1348831860',
    :MsgType => 'text',
    :Content => 'this is a test',
    :MsgId => '1234567890123456'
}

describe 'weixin message handler' do
  it 'should call text message handler when invoke handle with text message' do
    MessageDispatcher.any_instance.should_receive(:handle_text_message)
    dispatcher = MessageDispatcher.new
    dispatcher.on TEXT_MESSAGE_REQUEST
  end

  it 'should parse params from request' do
    dispatcher = MessageDispatcher.new
    dispatcher.parse_params(TEXT_MESSAGE_REQUEST).should == PARSED_PARAMS
  end

end