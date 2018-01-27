class TimeSlotType < ApplicationRecord
  has_one :time_slot

  validates :name, :slot_size, presence: true
end
