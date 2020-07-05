require 'signet/oauth_2/client'

class LoginController < ApplicationController
  protect_from_forgery with: :null_session

  def create
    client = Signet::OAuth2::Client.new(
        :token_credential_uri =>  'https://oauth2.googleapis.com/token',
        :client_id => ENV['GOOGLE_CLIENT_ID'],
        :client_secret => ENV['GOOGLE_CLIENT_SECRET'],
        :redirect_uri => 'postmessage',
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
