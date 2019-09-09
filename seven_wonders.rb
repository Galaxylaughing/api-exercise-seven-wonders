require 'httparty'
require 'dotenv'

Dotenv.load

#Starter Code:
seven_wonders = ["Great Pyramid of Giza", "Hanging Gardens of Babylon", "Colossus of Rhodes", "Pharos of Alexandria", "Statue of Zeus at Olympia", "Temple of Artemis", "Mausoleum at Halicarnassus"]

BASE_URL = "https://us1.locationiq.org/v1/search.php?key=YOUR_PRIVATE_TOKEN&q=SEARCH_STRING&format=json"
api_key = ENV['GEOCODING_API']

query = {
  key: api_key,
  q: "",
  format: "json"
}

seven_wonders_data = seven_wonders.map do |wonder|
  # Code to discover the locations of each wonder.
  query[:q] = wonder
  sleep(1)
  response = HTTParty.get(BASE_URL, query: query)
  
  begin
    response[0]
    # wonder_hash = {
    #   wonder => {
    #     "lat" => response[0]["lat"],
    #     "lng" => response[0]["lon"],
    #   }
    # }
  rescue NoMethodError
    "not there"
  end
  
end


seven_wonders_locations = {}
index = 0
seven_wonders_data.each do |response_hash|
  wonder = seven_wonders[index]
  
  seven_wonders_locations[wonder] = {}
  begin
    seven_wonders_locations[wonder]["lat"] = response_hash["lat"].to_f
    seven_wonders_locations[wonder]["lng"] = response_hash["lon"].to_f
  rescue NoMethodError
    seven_wonders_locations[wonder]["lat"] = "no latitude"
    seven_wonders_locations[wonder]["lng"] = "no longitude"
  end
  index += 1
end

p seven_wonders_locations



#Example Output:
#{"Great Pyramind of Giza"=>{"lat"=>29.9792345, "lng"=>31.1342019}, "Hanging Gardens of Babylon"=>{"lat"=>32.5422374, "lng"=>44.42103609999999}, "Colossus of Rhodes"=>{"lat"=>36.45106560000001, "lng"=>28.2258333}, "Pharos of Alexandria"=>{"lat"=>38.7904054, "lng"=>-77.040581}, "Statue of Zeus at Olympia"=>{"lat"=>37.6379375, "lng"=>21.6302601}, "Temple of Artemis"=>{"lat"=>37.9498715, "lng"=>27.3633807}, "Mausoleum at Halicarnassus"=>{"lat"=>37.038132, "lng"=>27.4243849}}

# seven_wonders_locations:
# {"Great Pyramid of Giza"=>{"lat"=>29.9791264, "lng"=>31.1342383751015}, "Hanging Gardens of Babylon"=>{"lat"=>"no latitude", "lng"=>"no longitude"}, "Colossus of Rhodes"=>{"lat"=>36.3397076, "lng"=>28.2003164}, "Pharos of Alexandria"=>{"lat"=>30.94795585, "lng"=>29.5235626430011}, "Statue of Zeus at Olympia"=>{"lat"=>37.6379088, "lng"=>21.6300063}, "Temple of Artemis"=>{"lat"=>40.7801086, "lng"=>24.7147622}, "Mausoleum at Halicarnassus"=>{"lat"=>37.03785995, "lng"=>27.4241280469557}}
