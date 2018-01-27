class Calendar < ApplicationRecord
  has_many :time_slots, inverse_of: :calendar
  has_many :appointments, inverse_of: :calendar

  validates :name, presence: true
end
