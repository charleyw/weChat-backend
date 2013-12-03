require 'sinatra'
require 'nokogiri'
require './ai_bang_client'
require './bus_helper'

get "/" do
  params[:echostr]
end

post "/" do
  doc = Nokogiri::XML::Document.parse request.body
  myAccount = doc.at_css("ToUserName").child.text;
  userAccount = doc.at_css("FromUserName").child.text;
  query = doc.at_css("Content").child.text;

  aibang_client = AiBangClient.new 'http://openapi.aibang.com/bus', '517dead47985e41ec11baa38362be69d'
  bus_helper = BusHelper.new aibang_client
  haml :weixin_text, locals: { myAccount: myAccount, userAccount: userAccount, content: bus_helper.bus_lines_running_time(query) }
end

helpers do
  def cdata content
    "<![CDATA[#{content}]]>"
  end
end