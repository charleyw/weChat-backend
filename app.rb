require 'sinatra'
require 'nokogiri'
require 'yaml'

require './ai_bang_client'
require './bus_helper'

CONFIG = YAML.load_file('./config/production.yml')

get "/" do
  params[:echostr]
end

post "/" do
  doc = Nokogiri::XML::Document.parse request.body
  message_type = doc.at_css("MsgType").child.text
  request_content = send :"#{message_type}_request_body", doc

  haml :weixin_text, :locals => {
      :myAccount => doc.at_css("ToUserName").child.text,
      :userAccount => doc.at_css("FromUserName").child.text,
      :content => send(:"on_#{message_type}_message", request_content)
  }
end

def on_text_message request_content
  aibang_client = AiBangClient.new CONFIG[:ai_bang_api], CONFIG[:ai_bang_api_key]
  bus_helper = BusHelper.new aibang_client
  bus_helper.bus_lines_running_time(request_content)
end

def text_request_body doc
  doc.at_css('Content').child.text
end

def on_event_message request_content
  if request_content.eql? 'subscribe'
    CONFIG[:subscribe_message]
  else
    CONFIG[:unsubscribe_message]
  end
end

def event_request_body doc
  doc.at_css('Event').child.text
end

def on_voice_message request_content
  logger.info "received voice Recognition message:\n\t#{request_content}"
end

def voice_request_body doc
  doc.at_css('Recognition').child.text
end

helpers do
  def cdata content
    "<![CDATA[#{content}]]>"
  end
end