class WeiXinRequestHandler
  def initialize config
    @config = config
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
end
