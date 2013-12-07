require 'yaml'

require './lib/ai_bang_client'
require './lib/bus_helper'
require './lib/message_dispatcher'

CONFIG = YAML.load_file("./config/#{ENV['RACK_ENV']}.yml")

on_text do
  aibang_client = AiBangClient.new CONFIG[:ai_bang_api], CONFIG[:ai_bang_api_key]
  bus_helper = BusHelper.new aibang_client
  bus_helper.bus_lines_running_time(params[:Content])
end

on_event do
  if params[:Content].eql? 'subscribe'
    CONFIG[:subscribe_message]
  else
    CONFIG[:unsubscribe_message]
  end
end

on_voice do
  puts 'on voice message'
end
