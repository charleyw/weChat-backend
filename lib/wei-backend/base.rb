module WeiBackend
  class MessageDispatcher
    attr_accessor :params

    def on message_type, params
      @params = params
      results = send(:"handle_#{message_type.downcase}_message")
      create_model results
    end

    def create_model data
      data.is_a?(Hash) || data.is_a?(Array) ? image_text_message(data) : text_message(data)
    end

    def text_message(data)
      {
          :format => 'text',
          :model => {:content => data}.merge(account_info)
      }
    end

    def image_text_message model
      {
          :format => 'image_text',
          :model => {
              :article_count => model.is_a?(Array) ? model.length : 1,
              :articles => model.is_a?(Array) ? model : [model]
          }.merge(account_info)
      }
    end

    def account_info
      {
          :myAccount => params[:ToUserName],
          :userAccount => params[:FromUserName],
      }
    end

    def self.on_text &block
      define_method(:handle_text_message, &block)
    end

    def self.on_event &block
      define_method(:handle_event_message, &block)
    end

    def self.on_voice &block
      define_method(:handle_voice_message, &block)
    end

    def self.on_location &block
      define_method(:handle_location_message, &block)
    end


  end

  module Delegator
    def self.delegate(*methods)
      methods.each do |method_name|
        define_method(method_name) do |*args, &block|
          Delegator.target.send(method_name, *args, &block)
        end
        private method_name
      end
    end

    delegate :on_text, :on_event, :on_voice, :on_location

    class << self
      attr_accessor :target
    end

    self.target = MessageDispatcher
  end
end
