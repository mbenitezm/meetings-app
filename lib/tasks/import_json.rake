namespace :import_json do
  task calendars: :environment do
    calendars = [
      JSON.parse(File.read('lib/assets/calendar1.json')),
      JSON.parse(File.read('lib/assets/calendar2.json')),
      JSON.parse(File.read('lib/assets/calendar3.json'))
    ]

    calendars.each do |calendar|
      import_calendar(calendar, 'Danny boy')
    end
  end

  def import_calendar(raw_calendar, name)
    calendar = Calendar.new(name: name,
                               uuid: '48644c7a-975e-11e5-a090-c8e0eb18c1e9')
    calendar.save

    raw_calendar['timeslottypes'].each do |raw_data|
      if TimeSlotType.find_by(uuid: raw_data['id'])
        next
      else
        time_slot_type_attributes = {
          uuid: raw_data['id'],
          name: raw_data['name'],
          slot_size: raw_data['slot_size']
        }
        TimeSlotType.create(time_slot_type_attributes)
      end
    end

    raw_calendar['appointments'].each do |raw_data|
      time_slot_type = TimeSlotType.find_by(uuid: raw_data['time_slot_type_id'])

      appointment_attributes = {
        calendar_id: calendar.id,
        uuid: raw_data['id'],
        start: raw_data['start'],
        end: raw_data['end'],
        completed: raw_data['completed']
      }
      appointment = Appointment.new(appointment_attributes)
      appointment.save

      TimeSlot.create(calendar_id: calendar.id, appointment_id: appointment.id,
                      time_slot_type_id: time_slot_type.id,
                      start: raw_data['start'], end: raw_data['end'])
    end

    raw_calendar['timeslots'].each do |raw_data|
      time_slot_type = TimeSlotType.find_by(uuid: raw_data['type_id'])

      time_slot_attributes = {
        time_slot_type_id: time_slot_type.id,
        calendar_id: calendar.id,
        start: raw_data['start'],
        end: raw_data['end']
      }
      TimeSlot.create(time_slot_attributes)
    end
  end
end