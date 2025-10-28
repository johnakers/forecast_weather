class FetchForecastsJob < ApplicationJob
  queue_as :default

  def perform(address_id)
    address = Address.find_by(id: address_id)

    return if address&.lat.nil? || address&.nil?

    cached = cachhed_weather_report(address)

    if cached
      address.update(forecasted_at: cached.forecasted_at)
      return
    end

    google_weather_response = Google::Weather.forecast(lat: address.lat, lng: address.lng)

    # icon need .png/.svg appended per documentation: https://developers.google.com/maps/documentation/weather/weather-condition-icons
    # dates are 'normalized' to be human readable
    #   feature: if we wanted to search by date, we would have a real DateTime object here
    google_weather_response.each do |forecast_data|
      forecast = Forecast.create!(
        icon: "#{forecast_data[:icon]}.png",
        max: forecast_data.dig(:max, 'degrees'),
        min: forecast_data.dig(:min, 'degrees'),
        normalized_date: normalized_date(forecast_data[:date])
      )

      WeatherReport.create!(
        address_id: address_id,
        forecast_id: forecast.id,
      )
    end

    address.update(forecasted_at: Time.current)
  end

  private

  def normalized_date(date_object)
    month_number = date_object['month']

    "#{date_object['day']} #{Date::MONTHNAMES[month_number][...3]}, #{date_object['year']}"
  end

  def cachhed_weather_report(address)
    #
    mins = ENV['FORECAST_CACHE_MINUTES'].to_i || 30

    cached_address = Address.find_by(
      postal_code: address.postal_code,
      forecasted_at: 30.minutes.ago..
    )

    return unless cached_address

    cached_address.weather_reports.each do |wr|
      WeatherReport.create!(
        address_id: address.id,
        forecast_id: wr.forecast_id
      )
    end

    cached_address
  end
end
