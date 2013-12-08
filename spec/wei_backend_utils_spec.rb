require_relative 'spec_helper'

PARSED_PARAMS={
    :ToUserName => 'toUser',
    :FromUserName => 'fromUser',
    :CreateTime => '1348831860',
    :MsgType => 'text',
    :Content => 'this is a test',
    :MsgId => '1234567890123456'
}

describe 'weixin backend utils' do
  it 'should parse params from request' do
    WeiBackend::Utils.parse_params(TEXT_MESSAGE_REQUEST).should == PARSED_PARAMS
  end
end