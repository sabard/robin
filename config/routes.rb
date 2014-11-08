Rails.application.routes.draw do
  root 'statics#home'
  get '/trigger_event/:type', to: 'events#trigger'
end
