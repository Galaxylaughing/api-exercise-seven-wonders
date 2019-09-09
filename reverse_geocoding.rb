require 'httparty'
require 'dotenv'

Dotenv.load

unknown_locations = [{ lat: 38.8976998, lon: -77.0365534886228}, {lat: 48.4283182, lon: -123.3649533 }, { lat: 41.8902614, lon: 12.493087103595503}]

BASE_URL = "https://us1.locationiq.org/v1/reverse.php?key=YOUR_PRIVATE_TOKEN&lat=LATITUDE&lon=LONGITUDE&format=json"
api_key = ENV['GEOCODING_API']

query = {
  key: api_key,
  lat: "",
  lon: "",
  format: "json"
}

locations_data = unknown_locations.map do |location|
  # Code to discover the locations of each wonder.
  query[:lat] = location[:lat]
  query[:lon] = location[:lon]
  sleep(1)
  response = HTTParty.get(BASE_URL, query: query)
  
  begin
    response["address"]
  rescue NoMethodError
    "not there"
  end
  
end


known_locations = {}
index = 0

locations_data.each do |response_hash|
  
  if response_hash["name"]
    place_name = response_hash["name"]
  elsif response_hash["house_number"] && response_hash["road"]
    place_name = "#{response_hash["house_number"]} #{response_hash["road"]}"
  else
    place_name = response_hash["road"]
  end
  
  known_locations[place_name] = response_hash
  
  index += 1
end

p known_locations

# known_locations:
# {"1600 Pennsylvania Avenue Northwest"=>{"house_number"=>"1600", "road"=>"Pennsylvania Avenue Northwest", "neighbourhood"=>"White House Grounds", "city"=>"Washington", "county"=>"District of Columbia", "state"=>"District of Columbia", "country"=>"United States", "postcode"=>"20006", "country_code"=>"us"}, "The Hands of Time: Carrying Books"=>{"name"=>"The Hands of Time: Carrying Books", "neighbourhood"=>"Chinatown", "city"=>"Victoria", "county"=>"Capital", "state"=>"British Columbia", "country"=>"Canada", "country_code"=>"ca"}, "Colosseo/Salvi"=>{"name"=>"Colosseo/Salvi", "neighbourhood"=>"San Paolo", "city"=>"Rome", "state"=>"Roma", "country"=>"Italy", "country_code"=>"it"}}