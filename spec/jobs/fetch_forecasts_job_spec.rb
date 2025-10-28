require 'rails_helper'

RSpec.describe FetchForecastsJob, type: :job do
  let(:address) { FactoryBot.create(:address, lat: 37.791637, lng: -122.4436991) }
  let(:google_geocode_response) do
    {
      'lat' => 37.791637,
      'lng' => -122.4436991,
      'postal_code' => '94102',
      'formatted_address' => 'San Francisco City Hall',
      'status' => 'OK'
    }
  end

  before do
    allow(Google::Geocode).to receive(:parse_address).and_return(google_geocode_response)
  end

  context "when postal_code exists" do
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

    it "creates WeatherReports for the associated address_id" do
      allow(HTTParty).to receive(:get).and_return(mock_weather_response)

      expect {
        FetchForecastsJob.perform_now(address.id)
      }.to change(WeatherReport, :count).by(2)
    end

    it "creates Forecasts for the associated address_id" do
      allow(HTTParty).to receive(:get).and_return(mock_weather_response)

      expect {
        FetchForecastsJob.perform_now(address.id)
      }.to change(Forecast, :count).by(1)
    end

    it "populates :forecasted_at on the associated Address" do
      allow(HTTParty).to receive(:get).and_return(mock_weather_response)

      FetchForecastsJob.perform_now(address.id)

      address.reload
      expect(address.forecasted_at).not_to be_nil
    end
  end
end
