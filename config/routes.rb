Rails.application.routes.draw do
  root 'time_slots#find'

  get 'calendar/:id', to: 'calendar#show', as: 'calendar'
  get 'time_slots', to: 'time_slots#show', as: 'show_time_slots'
end
