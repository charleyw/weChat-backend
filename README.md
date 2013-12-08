微信公众平台后台框架
========
## 如何安装:
* ### 使用bundler
	将`wei-backend`添加到`Gemfile`里：
	
		gem 'wei-backend'

* ### 使用`gem`直接安装：

		gem install wei-backend

## 如何使用
* 创建一个文件，如app.js，写入如下内容：

		require ‘sinatra’
		require 'wei-backend'
		
		on_text do
			"Received a text message: #{params[:Content]}!!, and send back a text message!"
		end

* 启动
 
		ruby app.rb
* 测试

	```
curl -H 'Content-type:text/xml' -d@- localhost:4567 << EOF
	<xml>
	 <ToUserName><![CDATA[toUser]]></ToUserName>
	 <FromUserName><![CDATA[fromUser]]></FromUserName> 
	 <CreateTime>1348831860</CreateTime>
	 <MsgType><![CDATA[text]]></MsgType>
	 <Content><![CDATA[This is a text message]]></Content>
	 <MsgId>1234567890123456</MsgId>
	</xml>
EOF
	
	```	
	
	将会得到一段text返回值，一切OK:
	
	```
<xml>
	<ToUserName><![CDATA[fromUser]]></ToUserName>
	<FromUserName><![CDATA[toUser]]></FromUserName>
	<CreateTime><![CDATA[1386522760]]></CreateTime>
	<MsgType><![CDATA[text]]></MsgType>
	<Content><![CDATA[Received a text message: This is a text message!!, and send back a text message!]]></Content>
</xml>

	```
	
## 接口说明：
		
1. ### on_text
当用户向微信公众发送消息的时候，微信会POST一段XML到公众号的后台服务器，`on_text`方法中定义的代码会处理这个请求，这`on_text`方法中可以访问到的请求参数：

	* `params[:ToUserName]`: 发送请求的用户
	* `params[:FromUserName]`: 公众号用户
	* `params[:CreateTime]`: 创建时间
	* `params[:MsgType]`: 消息类型，在这里是text
	* `params[:Content]`: 消息内容

1. ### on_event
处理微信发送过来的event请求:

	* `params[:ToUserName]`: 发送请求的用户
	* `params[:FromUserName]`: 公众号用户
	* `params[:CreateTime]`: 创建时间
	* `params[:MsgType]`: 消息类型，在这里是event
	* `params[:Event]`: 消息内容，如_**subscribe**_, _**unsubscribe**_


1. ### on_location
当用户想微信公众号分享位置信息时，微信会POST相应的位置信息到公众号后台服务器		
	* `params[:ToUserName]`: 发送请求的用户
	* `params[:FromUserName]`: 公众号用户
	* `params[:CreateTime]`: 创建时间
	* `params[:MsgType]`: 消息类型，在这里是location
	* `params[:Latitude]`: 地理位置纬度
	* `params[:Longitude]`: 地理位置经度				* `params[:Precision]`: 地理位置精度
		 			