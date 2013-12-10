require 'sinatra'
require 'wei-backend'

on_location do
  "You location:\n\t lat: #{params[:Latitude]} \n\t long: #{params[:Longitude]}"
end

on_subscribe do
  "Please share your location information"
end

on_text do

  #"hello world #{params[:Latitude]}"
  [{:title=>"", :description=>"", :picturl=>"", :url=>""},{:title=>"", :description=>"", :picturl=>"", :url=>""}]
end

