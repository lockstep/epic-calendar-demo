Rails.application.routes.draw do
  devise_for :users

  unauthenticated :user do
    get '/redirect', to: 'calendars#redirect', as: 'redirect'
    get '/callback', to: 'calendars#callback', as: 'callback'
    get '/calendars', to: 'calendars#calendars', as: 'calendars'
    get '/events/:calendar_id', to: 'calendars#events', as: 'events', calendar_id: /[^\/]+/

    root to: 'pages#landing'
  end
end
