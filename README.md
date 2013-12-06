微信公众平台后台框架
========
## Ruby version:
**ruby-2.0.0-p247**

可以使用[rvm](http://rvm.io)安装：

	rvm install ruby-2.0.0-p247

## 如何定制
* 启动
 
		git clone https://github.com/charleyw/weixin-sinatra.git
		bundle install
		rake dev:start 
* 所有的业务逻辑可以查看`lib/wei_xin_request_handler`		

访问`http://localhost:9393?echostr=test`,页面会显示**echostr**的值

## 如何部署
	git clone https://github.com/charleyw/weixin-sinatra.git
	bundle install
	rake prod:start