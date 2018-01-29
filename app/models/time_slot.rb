class TimeSlot < ApplicationRecord
  include Finder

  belongs_to :calendar, inverse_of: :time_slots
  belongs_to :appointment, optional: true
  belongs_to :time_slot_type, inverse_of: :time_slots

  delegate :slot_size, :name, to: :time_slot_type

  validates :start_time, :end_time, presence: true

  def self.available(params)
    Finder::TimeSlotFinder.new(params).find_time_slots
  end
end
