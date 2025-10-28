require 'rails_helper'

RSpec.describe Google::Weather do
  describe ".forecast" do
    let(:mock_weather_response) do
      {
        "forecastDays" =>
        [
          {
            "displayDate" => {"year" => 2025, "month" => 10, "day" => 28},
            "daytimeForecast" => {
              "interval" => {
                "startTime" => "2025-10-28T14:00:00Z",
                "endTime" => "2025-10-29T02:00:00Z"
              },
              "weatherCondition" => {
                "iconBaseUri" => "https://maps.gstatic.com/weather/v1/sunny",
                "description" => {
                  "text" => "Sunny", "languageCode" => "en"
                },
              },
            },
            "maxTemperature" => {"degrees" => 20.5, "unit" => "CELSIUS"},
            "minTemperature" => {"degrees" => 13.6, "unit" => "CELSIUS"},
          }
        ]
      }
    end

    it "returns the forecast for a given lat/lng" do
      allow(HTTParty).to receive(:get).and_return(mock_weather_response)
      expected_weather = [
        {
          date: {"year" => 2025, "month" => 10, "day" => 28},
          max: {"degrees" => 20.5, "unit" => "CELSIUS"},
          min: {"degrees" => 13.6, "unit" => "CELSIUS"},
          icon: "https://maps.gstatic.com/weather/v1/sunny",
          description: "Sunny"
        }
      ]

      lat = 37.7786871
      lng = -122.4212424
      weather = Google::Weather.forecast(lat:, lng:)

      expect(weather).to eq(expected_weather)
    end
  end
end

