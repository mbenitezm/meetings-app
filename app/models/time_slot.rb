class TimeSlot < ApplicationRecord
  belongs_to :calendar, inverse_of: :time_slots
  belongs_to :appointment, optional: true
  belongs_to :time_slot_type

  delegate :slot_size, :name, to: :time_slot_type

  validates :start, :end, presence: true

  MIN_SLOT_SIZE = 15

  def self.available(params)
    calendars = params['calendars']
    from = DateTime.parse(params['from']).beginning_of_hour()
    to = DateTime.parse(params['to'])
    slot_type = params['time_slot_type']
    duration = params['duration'].to_i
    minutes_interval = ((to.to_f - from.to_f) / 60).to_i

    calendars = time_slots_in_range(calendars, from, to, slot_type)
    minute_calendars = date_calendars_to_minutes(calendars, duration, from, minutes_interval)
    available_time_slots(minute_calendars, duration, minutes_interval).uniq { |ts| ts[:start] }
  end

  def self.time_slots_in_range(calendars, from, to, slot_type)
    calendars.map do |calendar_id|
      slots = Calendar.find(calendar_id).time_slots.where(appointment_id: nil)
      slots = slots.where("start >= ?", from).where("end <= ? ", to)

      !slot_type.blank? ? slots.where(time_slot_type_id: slot_type) : slots
    end
  end

  def self.date_calendars_to_minutes(calendar_slots, duration, from, minutes_interval)
    minute_calendars = calendar_slots.map { Array.new(minutes_interval) }

    calendar_slots.each_with_index do |calendar, i|
      calendar.each do |time_slot|
        minute_calendars[i] = mark_minutes_calendar(minute_calendars[i],time_slot, from)
      end
    end

    minute_calendars
  end

  def self.mark_minutes_calendar(minutes_calendar, time_slot, from)
    id = time_slot.id
    start = time_slot.start
    slot_size = time_slot.slot_size
    minute_index = ((start - from) / 60).to_i

    for i in minute_index..minute_index + slot_size - 1
      minutes_calendar[i] = id
    end

    minutes_calendar
  end

  def self.available_time_slots(minute_calendars, duration, minutes_interval)
    available_slots = []
    first_calendar = minute_calendars[0]

    (0..minutes_interval - 1).step(MIN_SLOT_SIZE) do |minute|
      if self.valid_slot?(minute_calendars, minute, duration)
        first_slot_id = first_calendar[minute]
        last_slot_id = first_calendar[minute + duration - 1]

        available_slot = {
          start: TimeSlot.find(first_slot_id).start,
          end: TimeSlot.find(last_slot_id).end
        }

        available_slots << available_slot
      end
    end

    available_slots
  end

  def self.valid_slot?(minute_calendars, minute, duration)
    for index in minute..minute + duration - 1
      if !minute_calendars.all? { |calendar| calendar[index] }
        return false
      end
    end
    true
  end
end
