class WeatherReport < ApplicationRecord
  belongs_to :address
  belongs_to :forecast
end
