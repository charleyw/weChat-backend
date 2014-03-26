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

  it 'should return image text format result when model contains article url' do
    dispatcher = WeiBackend::MessageDispatcher.new
    dispatcher.params=PARSED_PARAMS
    dispatcher.create_model({:article_url => "http://article_url/"}).should == {:format=>"image_text", :model=>{:article_count=>1, :articles=>[{:article_url=>"http://article_url/"}], :myAccount=>"toUser", :userAccount=>"fromUser"}}
  end

  it 'should return music text format result when model contains music url' do
    dispatcher = WeiBackend::MessageDispatcher.new
    dispatcher.params=PARSED_PARAMS
    dispatcher.create_model({:music_url => 'http://music_url/'}).should == {:format=>"music", :model=>{:music => {:music_url=> 'http://music_url/'}, :myAccount=>"toUser", :userAccount=>"fromUser"}}
  end

end