require_relative 'spec_helper'
require_relative '../lib/wei-backend/base'

describe 'weixin message handler' do
  it 'should call text message handler when invoke handle with text message' do
    WeiBackend::MessageDispatcher.any_instance.should_receive(:handle_text_message) { 'results' }
    dispatcher = WeiBackend::MessageDispatcher.new
    dispatcher.on('text', PARSED_PARAMS).should == {:format => 'text', :model => {:content => 'results', :myAccount=>"toUser", :userAccount=>"fromUser"}}
  end

  it 'should return text format result when model is a string' do
    dispatcher = WeiBackend::MessageDispatcher.new
    dispatcher.params=PARSED_PARAMS
    dispatcher.create_model('text results').should == {:format => 'text', :model => {:content => 'text results', :myAccount=>"toUser", :userAccount=>"fromUser"}}
  end

  it 'should return image text format result when model is a hash' do
    dispatcher = WeiBackend::MessageDispatcher.new
    dispatcher.params=PARSED_PARAMS
    dispatcher.create_model({:url => "http://adc/"}).should == {:format=>"image_text", :model=>{:article_count=>1, :articles=>[{:url=>"http://adc/"}], :myAccount=>"toUser", :userAccount=>"fromUser"}}
  end

end