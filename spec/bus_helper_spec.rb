require 'rspec'
require_relative '../lib/ai_bang_client'
require_relative '../lib/bus_helper'

describe "bus helper" do

  it "should return bus running time when user search for line 6 running time and city is xi'an" do
    aibang_client = double(AiBangClient, :bus_lines => (JSON.parse IO.read('spec/fixtures/bus_lines_response.json'))["lines"]["line"])
    bus_helper = BusHelper.new aibang_client
    bus_helper.bus_lines_running_time("西安6路").should include "6\u8def(\u706b\u8f66\u7ad9\u897f-\u6021\u56ed\u8def\u5317\u53e3) 6:00-20:30"
  end

  it "should return bus running time when user search for line k700 running time and city is xi'an" do
    aibang_client = double(AiBangClient, :bus_lines => (JSON.parse IO.read('spec/fixtures/bus_lines_response.json'))["lines"]["line"])
    bus_helper = BusHelper.new aibang_client
    bus_helper.bus_lines_running_time("西安k700路").should include "6\u8def(\u706b\u8f66\u7ad9\u897f-\u6021\u56ed\u8def\u5317\u53e3) 6:00-20:30"
  end

end