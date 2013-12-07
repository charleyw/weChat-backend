class WeiXinMessageDispatcher
  attr_accessor :params

  def on request_body
    @params = parse_params request_body
    msg_type = params[:MsgType]
    send(:"handle_#{msg_type}_message")
  end

  def self.on_text_message
    define_method(:handle_text_message, &block)
  end

  def self.on_event_message
    define_method(:handle_event_message, &block)
  end

  def handle_text_message request_content
    aibang_client = AiBangClient.new @config[:ai_bang_api], @config[:ai_bang_api_key]
    bus_helper = BusHelper.new aibang_client
    bus_helper.bus_lines_running_time(request_content)
  end

  def text_request_body doc
    doc.at_css('Content').child.text
  end

  def handle_event_message request_content
    if request_content.eql? 'subscribe'
      @config[:subscribe_message]
    else
      @config[:unsubscribe_message]
    end
  end

  def event_request_body doc
    doc.at_css('Event').child.text
  end

  def handle_voice_message request_content
  end

  def voice_request_body doc
    doc.at_css('Recognition').child.text
  end

  def parse_params(request_body)
    doc = Nokogiri::XML::Document.parse request_body
    result = {}
    doc.at_css('xml').children.each do |child|
      result[child.name.to_sym] = child.child.text
    end
    result
  end
end
