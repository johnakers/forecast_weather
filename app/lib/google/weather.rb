module Google
  class Weather
    attr_reader :lat, :lng
    def initialize(lat:, lng:)
      @lat = lat
      @lng = lng
    end

    def self.forecast(lat:, lng:)
      new(lat:, lng:).forecast
    end

    def forecast
      forecast_weather_response = HTTParty.get(
        ENV['GOOGLE_FORECAST_WEATHER_URL'],
        query: {
          'location.latitude' => lat,
          'location.longitude' => lng,
          key: ENV['GOOGLE_API_KEY']
        }
      )

      forecast_weather_response['forecastDays'].map do |forecast|
        {
          date: forecast['displayDate'],
          max: forecast['maxTemperature'], # all temps are in CELSIUS
          min: forecast['minTemperature'],
          icon: forecast.dig('daytimeForecast', 'weatherCondition', 'iconBaseUri'),
          description: forecast.dig('daytimeForecast', 'weatherCondition', 'description', 'text')
        }
      end
    end
  end
end
