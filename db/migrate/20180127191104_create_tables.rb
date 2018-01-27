class CreateTables < ActiveRecord::Migration[5.0]
  def change
    create_table :calendars do |t|
      t.string :name
    end

    create_table :appointments do |t|
      t.integer  :calendar_id, index: true
      t.datetime :start
      t.datetime :end
      t.boolean  :completed, default: false
      t.timestamps null: false
    end

    create_table :time_slots do |t|
      t.integer  :calendar_id, index: true
      t.integer  :appointment_id, index: true
      t.integer  :time_slot_type_id, index: true
    end

    create_table :time_slot_types do |t|
      t.string   :name
      t.integer  :slot_size
    end
  end
end