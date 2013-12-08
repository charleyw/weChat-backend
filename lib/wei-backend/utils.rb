module WeiBackend
  module Utils
    def self.parse_params(request_body)
      doc = Nokogiri::XML::Document.parse request_body
      result = {}
      doc.at_css('xml').element_children.each do |child|
        result[child.name.to_sym] = child.child.text
      end
      result
    end
  end
end