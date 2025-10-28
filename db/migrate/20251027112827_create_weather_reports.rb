class CreateWeatherReports < ActiveRecord::Migration[8.0]
  def change
    create_table :weather_reports, id: :uuid do |t|
      t.uuid :address_id, null: false, index: true
      t.uuid :forecast_id, null: false, index: true
      t.timestamps
    end
  end
end
