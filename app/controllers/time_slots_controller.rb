class TimeSlotsController < ApplicationController
  def find
    @calendars = Calendar.all
    @time_slot_types = TimeSlotType.all
  end

  def show
    #binding.pry
  end
end
