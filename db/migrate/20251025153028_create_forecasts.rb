class CreateForecasts < ActiveRecord::Migration[8.0]
  def change
    create_table :forecasts, id: :uuid do |t|
      t.float :max, null: false
      t.float :min, null: false
      t.string :icon, null: false
      t.string :normalized_date, null: false

      t.timestamps
    end
  end
end
