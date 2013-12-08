require_relative 'spec_helper'

describe 'weixin backend utils' do
  it 'should parse params from request' do
    WeiBackend::Utils.parse_params(TEXT_MESSAGE_REQUEST).should == PARSED_PARAMS
  end
end