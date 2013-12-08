require 'sinatra'
require 'nokogiri'

get '/' do
  params[:echostr]
end

post '/' do
  request.body.rewind
  weixin_params = WeiBackend::Utils.parse_params request.body.read
  handler = WeiBackend::MessageDispatcher.new
  results = handler.on weixin_params[:MsgType], weixin_params

  haml results[:format].to_sym, :views => File.dirname(__FILE__)+'/wei-templates', :locals => results[:model]
end

helpers do
  def cdata content
    "<![CDATA[#{content}]]>"
  end
end

extend WeiBackend::Delegator
