module Finder
  class TimeSlotFinder
    MIN_SLOT_SIZE = 15

    def initialize(params)
      @calendars = params['calendars']
      @from = DateTime.parse(params['from']).beginning_of_hour()
      @to = DateTime.parse(params['to'])
      @slot_type = params['time_slot_type']
      @duration = params['duration'].to_i
      @minutes_interval = ((@to.to_f - @from.to_f) / 60).to_i
    end

    def find_time_slots
      calendars = filter_calendars
      minute_calendars = date_calendars_to_minutes(calendars)
      available_time_slots(minute_calendars).uniq { |ts| ts[:start] }
    end

    def filter_calendars
      @calendars.map do |calendar_id|
        slots = Calendar.find(calendar_id).time_slots.where(appointment_id: nil)
        slots = slots.where("start >= ?", @from).where("end <= ? ", @to)

        !@slot_type.blank? ? slots.where(time_slot_type_id: @slot_type) : slots
      end
    end

    def date_calendars_to_minutes(calendars)
      minute_calendars = calendars.map { Array.new(@minutes_interval) }

      calendars.each_with_index do |calendar, i|
        calendar.each do |time_slot|
          minute_calendars[i] = mark_minutes_calendar(minute_calendars[i],time_slot)
        end
      end

      minute_calendars
    end

    def mark_minutes_calendar(minutes_calendar, time_slot)
      id = time_slot.id
      start = time_slot.start
      slot_size = time_slot.slot_size
      minute_index = ((start - @from) / 60).to_i

      for i in minute_index..minute_index + slot_size - 1
        minutes_calendar[i] = id
      end

      minutes_calendar
    end

    def available_time_slots(minute_calendars)
      available_slots = []
      first_calendar = minute_calendars[0]

      (0..@minutes_interval - 1).step(MIN_SLOT_SIZE) do |minute|
        if valid_slot?(minute_calendars, minute)
          available_slots << slot_attributes(first_calendar, minute)
        end
      end

      available_slots
    end

    def slot_attributes(first_calendar, minute)
      first_slot_id = first_calendar[minute]
      last_slot_id = first_calendar[minute + @duration - 1]

      available_slot = {
        start: TimeSlot.find(first_slot_id).start,
        end: TimeSlot.find(last_slot_id).end
      }
    end

    def valid_slot?(minute_calendars, minute)
      for index in minute..minute + @duration - 1
        if !minute_calendars.all? { |calendar| calendar[index] }
          return false
        end
      end
      true
    end
  end
end
