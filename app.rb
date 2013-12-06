require 'sinatra'
require 'nokogiri'
require 'yaml'

require './lib/ai_bang_client'
require './lib/bus_helper'
require './lib/wei_xin_request_handler'

CONFIG = YAML.load_file("./config/#{ENV['RACK_ENV']}.yml")

get '/' do
  params[:echostr]
end

post '/' do
  doc = Nokogiri::XML::Document.parse request.body
  message_type = doc.at_css("MsgType").child.text

  handler = WeiXinRequestHandler.new CONFIG
  request_content = handler.send :"#{message_type}_request_body", doc

  haml :weixin_text, :locals => {
      :myAccount => doc.at_css("ToUserName").child.text,
      :userAccount => doc.at_css("FromUserName").child.text,
      :content => handler.send(:"handle_#{message_type}_message", request_content)
  }
end

helpers do
  def cdata content
    "<![CDATA[#{content}]]>"
  end
end