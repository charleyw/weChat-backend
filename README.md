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

## 模拟微信请求测试
微信的每一个请求都会带上3个参数，`timestamp`时间戳, `nonce`随机数以及`signature`由token和前两个参数生成的值。因此，模拟测试需要生成token对应的signature:


```
export TIMESTAMP=1388674716
export NONCE=1388564676
export TOKEN=mytoken
export SIGNATURE=$(ruby -e 'require "digest/sha1"; puts Digest::SHA1.hexdigest [ENV["TIMESTAMP"], ENV["NONCE"], ENV["TOKEN"]].sort!.join')
curl -H 'Content-type:text/xml' -d@- localhost:4567/weixin?signature=$SIGNATURE&timestamp=$TIMESTAMP&nonce=$NONCE << EOF
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

将会得到一段xml返回值，表示一切OK:

```
<xml>
	<ToUserName><![CDATA[fromUser]]></ToUserName>
	<FromUserName><![CDATA[toUser]]></FromUserName>
	<CreateTime><![CDATA[1386522760]]></CreateTime>
	<MsgType><![CDATA[text]]></MsgType>
	<Content><![CDATA[你发送了如下内容: This is a text message]]></Content>
</xml>

```

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

	
## 接口说明：
各个接口只能定义一次，重复定义会覆盖之前定义的接口

* ### token
用来配置你在微信公众平台设置的token，token的作用是用来的验证微信的请求是否合法。请确保你的token和微信公众平台设置的token一致。
		
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

© 2014 Wang Chao. This code is distributed under the MIT license.

