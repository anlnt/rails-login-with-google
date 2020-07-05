require 'signet/oauth_2/client'

class LoginController < ApplicationController
  protect_from_forgery with: :null_session

  def create
    client = Signet::OAuth2::Client.new(
        :authorization_uri => 'https://accounts.google.com/o/oauth2/auth',
        :token_credential_uri =>  'https://oauth2.googleapis.com/token',
        :client_id => ENV['GOOGLE_CLIENT_ID'],
        :client_secret => ENV['GOOGLE_CLIENT_SECRET'],
        :scope => params[:scope],
        :grant_type => 'authorization_code',
        :redirect_uri => 'postmessage',
        :additional_parameters => {
            :access_type => "offline"
        }
    )
    client.code = params[:code]
    gg_access_token = client.fetch_access_token!
    puts user_info(gg_access_token['id_token'])
  end

  def user_info(gg_id_token)
    decoded_token = JWT.decode gg_id_token, nil, false
    {
        hosted_domain: decoded_token[0]['hd'],
        email: decoded_token[0]['email'],
        name: decoded_token[0]['name'],
        picture: decoded_token[0]['picture']
    }
  end
end
