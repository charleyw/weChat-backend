require 'sinatra'
require 'nokogiri'

get '/' do
  params[:echostr]
end

post '/' do
  request.body.rewind
  doc = Nokogiri::XML::Document.parse request.body.read
  handler = WeiBackend::MessageDispatcher.new
  request.body.rewind
  haml :weixin_text, :views=>File.dirname(__FILE__)+'/views', :locals => {
      :myAccount => doc.at_css('ToUserName').child.text,
      :userAccount => doc.at_css('FromUserName').child.text,
      :content => handler.on(request.body.read)
  }
end

helpers do
  def cdata content
    "<![CDATA[#{content}]]>"
  end
end

extend WeiBackend::Delegator
