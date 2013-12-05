class BusHelper
  def initialize(ai_bang_client)
    @ai_bang_client = ai_bang_client
  end

  def bus_lines_running_time(query)
    lines = query.scan(/\w*\d+/)
    bus_num = lines[0].strip if lines.length > 0
    city = query.sub(/#{bus_num}.*/, '').strip
    city = "西安" if city.empty?
    bus_lines_results = @ai_bang_client.bus_lines(city, bus_num)
    result = "";
    bus_lines_results.each do |line|
      running_time = line["info"].scan(/\d{1,2}[:：]\d{1,2}-{1,2}\d{1,2}[:：]\d{1,2}/)[0]
      result += line["name"] + " " + running_time + "\n\n" if !running_time.nil?
    end
    result
  end
end