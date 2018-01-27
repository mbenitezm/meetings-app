Rails.application.routes.draw do
  root 'time_slots#index'

  get 'calendar/:id', to: 'calendar#show', as: 'calendar'
end
