module Google
  class Geocode
    attr_reader :address_string, :raw_data, :lat, :lng, :formatted_address
    def initialize(address_string:)
      @address_string = address_string
      @raw_data = {}
      @lat = nil
      @lng = nil
      @formatted_address = ''
    end

    def self.parse_address(address_string:)
      new(address_string:).parse_address
    end

    def parse_address
      response = HTTParty.get(
        ENV['GOOGLE_GEOCODE_URL'],
        query: {
          address: address_string,
          key: ENV['GOOGLE_API_KEY']
        }
      )

      # parses just the postal code from the object
      postal_code = response['results'].first['address_components'].find do |comp|
        comp['types'] == ['postal_code']
      end

      # FIXME/NOTE: entering some international addresses does not return a postal code 🤔
      #             not within the short term scope but leveraging "administrative" and/or
      #             "political" address_components would be ideal but postal_code logic would need
      #             to be extended
      postal_code = postal_code['long_name'] if postal_code

      response['results'].first['geometry']['location'].merge(
        {
          'postal_code' => postal_code,
          'formatted_address' => response['results'].first['formatted_address'],
          'status' => response['status']
        }
      )
    end
  end
end

# Example response for US addresses. See above comment for *some* international addresses
#
# {
#   "results" =>
#     [{"address_components" =>
#       [{"long_name" => "94102",
#         "short_name" => "94102",
#         "types" => ["postal_code"]},
#         {"long_name" => "San Francisco",
#         "short_name" => "SF",
#         "types" => ["locality", "political"]},
#         {"long_name" => "San Francisco County",
#         "short_name" => "San Francisco County",
#         "types" => ["administrative_area_level_2", "political"]},
#         {"long_name" => "California",
#         "short_name" => "CA",
#         "types" => ["administrative_area_level_1", "political"]},
#         {"long_name" => "United States",
#         "short_name" => "US",
#         "types" => ["country", "political"]}],
#       "formatted_address" => "San Francisco, CA 94102, USA",
#       "geometry" =>
#       {"bounds" =>
#         {"northeast" =>
#           {"lat" => 37.789226, "lng" => -122.4034491},
#           "southwest" =>
#           {"lat" => 37.7694409, "lng" => -122.429849}},
#         "location" => {"lat" => 37.7786871, "lng" => -122.4212424},
#         "location_type" => "APPROXIMATE",
#         "viewport" =>
#         {"northeast" =>
#           {"lat" => 37.789226, "lng" => -122.4034491},
#           "southwest" =>
#           {"lat" => 37.7694409, "lng" => -122.429849}}},
#       "place_id" => "ChIJs88qnZmAhYARk8u-7t1Sc2g",
#       "types" => ["postal_code"]}],
#   "status" => "OK"
# }
