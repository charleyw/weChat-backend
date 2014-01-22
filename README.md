<script>
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

  ga('create', 'UA-46801609-2', 'github.com');
  ga('send', 'pageview');

</script>
## 微信公众平台后台框架
[![Build Status](https://travis-ci.org/charleyw/weChat-backend.png?branch=master)](https://travis-ci.org/charleyw/weChat-backend)

微信公众平台 后台框架，基于sinatra，使用DSL的思想帮助你以最快的**速度**开启微信公众平台开发. 

## 仅需3步,一个文件创建一个微信后台程序
1. 安装Gem

		gem install 'wei-backend'

1. 创建微信后台主程序**app.rb**, 内容如下：
	
		require 'sinatra'
		require 'wei-backend'
		
		token "mytoken"
		
		on_text do
			"你发送了如下内容: #{params[:Content]}!!"
		end
			
		on_subscribe do
			"感谢您的订阅"
		end
			
		on_unsubscribe do
			"欢迎您再次订阅"
		end

1. 启动	

		ruby app.rb		

## 与微信接口兼容情况：

* 现在可以处理的消息类型（被动接受用户消息类型）：

	| 消息类型 | 接口 |
	| ------------ | ------------- |
	| 文本消息 | on_text  |
	| 订阅事件 | on_subscribe  |
	| 取消订阅事件 | on_unsubscribe  |
	| 用户被动分享地理位置 | on_location  |

	后续还会加入消息类型支持

* 可以发送的消息类型：

	| 消息类型 | 格式 |
	| ------------ | ------------- |
	| 文本消息 | ruby 字符串  |
	| 图文事件 | ruby hash值  |

## 如何使用
* 创建一个文件，如app.rb，写入如下内容：

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
各个接口只能定义一次，重复定义会覆盖之前定义的接口
		
* ### on_text
当用户向微信公众发送消息的时候，微信会POST一段XML到公众号的后台服务器，`on_text`方法中定义的代码会处理这个请求，这`on_text`方法中可以访问到的请求参数：

	* `params[:ToUserName]`: 发送请求的用户
	* `params[:FromUserName]`: 公众号用户
	* `params[:CreateTime]`: 创建时间
	* `params[:MsgType]`: 消息类型，在这里是text
	* `params[:Content]`: 消息内容

* ### on_subscribe
当用户关注时，处理消息的接口:

	* `params[:ToUserName]`: 发送请求的用户
	* `params[:FromUserName]`: 公众号用户
	* `params[:CreateTime]`: 创建时间
	* `params[:MsgType]`: 消息类型，在这里是event
	* `params[:Event]`: 事件类型，_**subscribe**_

* ### on_unsubscribe
当用户取消关注时，处理消息的接口:

	* `params[:ToUserName]`: 发送请求的用户
	* `params[:FromUserName]`: 公众号用户
	* `params[:CreateTime]`: 创建时间
	* `params[:MsgType]`: 消息类型，在这里是event
	* `params[:Event]`: 事件类型，_**unsubscribe**_



* ### on_location
当用户向微信公众号分享位置信息时，微信会POST相应的位置信息到公众号后台服务器
	* `params[:ToUserName]`: 发送请求的用户
	* `params[:FromUserName]`: 公众号用户
	* `params[:CreateTime]`: 创建时间
	* `params[:MsgType]`: 消息类型，在这里是location
	* `params[:Location_X]`: 地理位置纬度
	* `params[:Location_Y]`: 地理位置经度
	* `params[:Scale]`: 地图缩放大小
	* `params[:Label]`: 地理位置信息

## 返回消息
* 返回文本消息：

		on_text do
			"Received a text message: #{params[:Content]}!!, and send back a text message!"
		end
		
* 返回图文消息

		on_text do
          [{
               :title => '收到一个文本消息，返回两个图文消息',
               :description => 'desc',
               :picture_url => 'pic url',
               :url => 'url'
           },
           {
               :title => '这是第二个图文消息',
               :description => 'desc1',
               :picture_url => 'pic url1',
               :url => 'url1'
           }]
		end
	
## Liscense

© 2013 Wang Chao. This code is distributed under the MIT license.

[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/charleyw/wechat-backend/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

