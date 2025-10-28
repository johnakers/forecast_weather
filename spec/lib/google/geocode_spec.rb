require 'rails_helper'

RSpec.describe Google::Geocode do
  describe ".parse_address" do
    let(:mock_geocode_response) do
      {
        "results" => [{
          "address_components" => [{
              "long_name" => "94118",
              "short_name" => "94118",
              "types" => ["postal_code"]
            },
            {
              "long_name" => "San Francisco",
              "short_name" => "SF",
              "types" => ["locality", "political"]
            },
            {
              "long_name" => "San Francisco County",
              "short_name" => "San Francisco County",
              "types" => ["administrative_area_level_2", "political"]
            },
            {
              "long_name" => "California",
              "short_name" => "CA",
              "types" => ["administrative_area_level_1", "political"]
            },
            {
              "long_name" => "United States",
              "short_name" => "US",
              "types" => ["country", "political"]
            }
          ],
          "formatted_address" => "San Francisco, CA 94118, USA",
          "geometry" => {
            "bounds" => {
              "northeast" => {
                "lat" => 37.791637, "lng" => -122.4436991
              },
              "southwest" => {
                "lat" => 37.766062, "lng" => -122.479504
              }
            },
            "location" => {
              "lat" => 37.7822891, "lng" => -122.463708
            },
            "location_type" => "APPROXIMATE",
            "viewport" => {
              "northeast" => {
                "lat" => 37.791637, "lng" => -122.4436991
              },
              "southwest" => {
                "lat" => 37.766062, "lng" => -122.479504
              }
            }
          },
          "place_id" => "ChIJE8NGljiHhYARnSY8nSgLJkk",
          "types" => ["postal_code"]
        }],
        "status" => "OK"
      }
    end

    it "returns the forecast for a given lat/lng" do
      allow(HTTParty).to receive(:get).and_return(mock_geocode_response)
      expected_geocode = {
        "lat" => 37.7822891,
        "lng" => -122.463708,
        "postal_code" => "94118",
        "formatted_address" => "San Francisco, CA 94118, USA",
        "status" => "OK"
      }

      geocode = Google::Geocode.parse_address(address_string: '94118')

      expect(geocode).to eq(expected_geocode)
    end
  end
end

