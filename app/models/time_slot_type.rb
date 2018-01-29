class TimeSlotType < ApplicationRecord
  has_many :time_slots, inverse_of: :time_slot_type

  validates :name, :slot_size, presence: true
end
