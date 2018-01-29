class TimeSlotsController < ApplicationController
  def find
    @calendars = Calendar.all
    @time_slot_types = TimeSlotType.all
  end

  def show
    @time_slots = TimeSlot.available(object_params)
  end

  private
  def object_params
    params.require(:time_slot).permit(:from, :to, :time_slot_type, :duration,
      calendars: [])
  end
end
