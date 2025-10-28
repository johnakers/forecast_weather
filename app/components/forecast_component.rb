class ForecastComponent < ViewComponent::Base
  def initialize(forecast:)
    @forecast = forecast
  end
end