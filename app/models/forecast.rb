class Forecast < ApplicationRecord
  has_many :weather_reports
  has_many :forecasts, through: :weather_reports
end
