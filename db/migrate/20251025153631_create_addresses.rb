class CreateAddresses < ActiveRecord::Migration[8.0]
  def change
    create_table :addresses, id: :uuid do |t|
      t.string :input, null: false
      t.string :formatted_address
      t.float :lat
      t.float :lng
      t.string :postal_code
      t.datetime :forecasted_at

      t.timestamps
    end
  end
end

# Example address JSON
# {
#   "input": "94102",
#   "lat": 37.7,
#   "lng": -122.4
# }
