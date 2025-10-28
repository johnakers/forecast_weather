class GeocodeAddressJob < ApplicationJob
  queue_as :default

  def perform(address_id)
    address = Address.find_by(id: address_id)

    return unless address

    geocode_data_response = Google::Geocode.parse_address(address_string: address.input)

    raise Exceptions::GoogleApiError unless geocode_data_response['status'] == 'OK'

    address.update(
      lat: geocode_data_response['lat'],
      lng: geocode_data_response['lng'],
      formatted_address: geocode_data_response['formatted_address'],
      postal_code: geocode_data_response['postal_code'],
    )

    FetchForecastsJob.perform_now(address_id)
  end
end
