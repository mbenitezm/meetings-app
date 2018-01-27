class Appointment < ApplicationRecord
  belongs_to :calendar, inverse_of: :appointments
  has_one :time_slot
end
