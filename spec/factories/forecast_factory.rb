FactoryBot.define do
  factory :forecast do
    max { 20.4 }
    min { 13.8 }
    icon { "https://maps.gstatic.com/weather/v1/sunny.svg" }
    normalized_date { "28 Oct, 2025" }
  end
end
