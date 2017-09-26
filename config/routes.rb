Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'sessions', omniauth_callbacks: 'callbacks' }

  unauthenticated :user do
    get '/redirect', to: 'calendars#redirect', as: 'redirect'
    get '/callback', to: 'calendars#callback', as: 'callback'

    root to: 'pages#landing'
  end

  authenticated :user do
    get '/calendars', to: 'calendars#calendars', as: 'calendars'
    get '/events/:calendar_id', to: 'calendars#events', as: 'events', calendar_id: /[^\/]+/

    root to: 'calendars#calendars'
  end
end
