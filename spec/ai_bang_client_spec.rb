require 'rspec'
require_relative '../lib/ai_bang_client'

class MockResponse
  def parsed_response
    JSON.parse IO.read('spec/fixtures/bus_lines_response.json')
  end
end
module HTTParty
  def self.get(*args, &block)
    MockResponse.new
  end
end

describe 'aibang api client' do

  it 'should bus lines as json object when search for line 6' do
    aibang_client = AiBangClient.new 'http://localhost/bus', 'api_key'
    aibang_client.bus_lines("city", "query").to_s.should include "6\\u8DEF(\\u6021\\u56ED\\u8DEF\\u5317\\u53E3-\\u706B\\u8F66\\u7AD9\\u897F)"
  end

end