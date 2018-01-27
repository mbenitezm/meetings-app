class TimeSlot < ApplicationRecord
  belongs_to :calendar, inverse_of: :time_slots
  belongs_to :appointment, optional: true
  belongs_to :time_slot_type

  delegate :slot_size, :name, to: :time_slot_type

  validates :start, :end, presence: true
end
