require_relative 'spec_helper'
require_relative '../lib/wei-backend/base'

describe 'weixin message handler' do
  it 'should call text message handler when invoke handle with text message' do
    WeiBackend::MessageDispatcher.any_instance.should_receive(:handle_text_message)
    dispatcher = WeiBackend::MessageDispatcher.new
    dispatcher.on TEXT_MESSAGE_REQUEST
  end

end