FactoryBot.define do
  factory :weather_report do
    association :address, factory: :address

    address_id {}
    forecast_id {}
  end
end

