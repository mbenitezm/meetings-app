class Calendar < ApplicationRecord
  has_many :time_slots, inverse_of: :calendar
  has_many :appointments, inverse_of: :calendar

  validates :name, presence: true

  def last_appointments
    appointments.where(completed: true).order(start: :desc).first(10)
  end

  def next_appointments
    appointments.where(completed: false).order(start: :desc)
  end
end
