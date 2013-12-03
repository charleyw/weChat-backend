require 'sinatra'
require 'nokogiri'

get "/" do
  params[:echostr]
end

post "/" do
  doc = Nokogiri::XML::Document.parse request.body
  myAccount = doc.at_css("ToUserName").child.text;
  userAccount = doc.at_css("FromUserName").child.text;
  content = doc.at_css("Content").child.text;
  haml :weixin_text, locals: { myAccount: myAccount, userAccount: userAccount, content: content }
end

helpers do
  def cdata content
    "<![CDATA[#{content}]]>"
  end
end