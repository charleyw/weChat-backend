require 'sinatra'
require 'nokogiri'
require 'digest/sha1'

set(:access_token) { |token_proc|
  condition do
    token = token_proc.call
    return true if token.nil? || token.empty?
    origin_signature_strings = [token, params[:timestamp], params[:nonce]]
    signature = Digest::SHA1.hexdigest origin_signature_strings.sort!.join
    signature.eql? params[:signature]
  end
}

token_proc = proc {
  WeiBackend::MessageDispatcher.token
}

get '/', :access_token => token_proc do
  params[:echostr]
end

post '/', :access_token => token_proc do
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
