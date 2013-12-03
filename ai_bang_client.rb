require 'httparty'
require 'uri'

class AiBangClient
  def initialize(api_base_url, api_key)
    %w(lines transfer stats).each do |category|
      instance_variable_set("@#{category}_api_url", api_base_url + "/#{category}?app_key=#{api_key}&alt=json")
    end
  end
  def bus_lines(city, query)
    encoded_city = URI.encode city
    encoded_query = URI.encode query
    api_url = "#{@lines_api_url}&city=#{encoded_city}&q=#{encoded_query}"
    result = HTTParty.get(api_url).parsed_response["lines"]
    result.has_key?('line') ? result['line'] : []
  end
end