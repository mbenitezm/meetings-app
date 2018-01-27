class CalendarController < ApplicationController
  def show
    calendar = Calendar.find(params[:id])
    @last_appointments = calendar.last_appointments
    @next_appointments = calendar.next_appointments
  end
end
