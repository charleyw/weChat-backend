class BusHelper
  def initialize(ai_bang_client)
    @ai_bang_client = ai_bang_client
  end

  def bus_lines_running_time(query)
    lines = query.scan(/\d+/)
    bus_num = lines[0] if lines.length > 0
    city = query.sub(/#{bus_num}.*/, '').strip
    city = "西安" if city.empty?
    bus_lines_results = @ai_bang_client.bus_lines(city, bus_num)
    result = "";
    bus_lines_results.each do |line|
      result += line["name"] + " " + line["info"].scan(/\d{1,2}:\d{1,2}-{1,2}\d{1,2}:\d{1,2}/)[0] + "\n\n"
    end
    result
  end
end