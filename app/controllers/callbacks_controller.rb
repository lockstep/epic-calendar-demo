require 'signet/oauth_2/client'
require 'googleauth'


class CallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    client = Signet::OAuth2::Client.new(client_options)
    client.code = params[:code]

    response = client.fetch_access_token!

    session[:authorization] = response

    @user = User.find_for_google_oauth2(request.env["omniauth.auth"])
    if @user
      sign_in @user
      redirect_to root_path
    else
      redirect_to new_user_session_path, notice: 'Access Denied.'
    end
  end

  private

  def client_options
    {
      client_id: ENV['GOOGLE_CLIENT_ID'],
      client_secret: ENV['GOOGLE_CLIENT_SECRET'],
      authorization_uri: 'https://accounts.google.com/o/oauth2/auth',
      token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
      scope: Google::Apis::CalendarV3::AUTH_CALENDAR,
      redirect_uri: user_google_oauth2_omniauth_callback_url
    }
  end
end
