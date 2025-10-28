class AddressesController < ApplicationController
  def index
    @address = Address.new
    @addresses = Address.all.order(created_at: :desc)
  end

  def create
    Address.create!(address_params)

    redirect_to addresses_path
  end

  def address_params
    params.require(:address).permit(:input)
  end
end
