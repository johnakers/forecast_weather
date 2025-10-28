class Address < ApplicationRecord
  has_many :weather_reports
  has_many :forecasts, through: :weather_reports

  after_create :geocode_address

  private

  # sets lat/lng
  # calls forecast job
  def geocode_address
    GeocodeAddressJob.perform_now(id)
  end
end
