# frozen_string_literal: true

class CalendarsController < ApplicationController

  def calendars
    client = Signet::OAuth2::Client.new(client_options)
    client.fetch_access_token!

    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = client

    @calendar_list = service.list_calendar_lists
  rescue Google::Apis::AuthorizationError
    response = client.refresh!

    session[:authorization] = session[:authorization].merge(response)

    retry
  end

  def events
    client = Signet::OAuth2::Client.new(client_options)
    client.fetch_access_token!

    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = client

    @event_list = service.list_events(params[:calendar_id])
  end

  private

  def client_options
    {
      client_id: ENV['GOOGLE_CLIENT_ID'],
      client_secret: ENV['GOOGLE_CLIENT_SECRET'],
      authorization_uri: 'https://accounts.google.com/o/oauth2/auth',
      token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
      scope: Google::Apis::CalendarV3::AUTH_CALENDAR,
      redirect_uri: user_google_oauth2_omniauth_authorize_url,
      refresh_token: current_user.refresh_token
    }
  end
end
