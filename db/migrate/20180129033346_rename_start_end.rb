class RenameStartEnd < ActiveRecord::Migration[5.0]
  def change
    rename_column :appointments, :start, :start_time
    rename_column :appointments, :end, :end_time
    rename_column :time_slots, :start, :start_time
    rename_column :time_slots, :end, :end_time
  end
end
