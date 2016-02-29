class OauthsController < ApplicationController
  skip_before_filter :require_login

  def oauth
    login_at(params[:provider])
  end

  def callback
    provider = auth_params['provider']
    begin
      if @user = login_from(provider)
        redirect_to root_path, :notice => "Logged in from #{provider.titleize}!"
      else
        begin
          @user = create_from(provider)

          reset_session # protect from session fixation attack
          auto_login(@user)
          redirect_to root_path, :notice => "Logged in from #{provider.titleize}!"
        rescue => e
          logger.error "Exception: #{e.message}"
          redirect_to root_path, :alert => "Failed to login from #{provider.titleize}!"
        end
      end

    rescue OAuth2::Error => oae
      render inline: oae.message
    end
  end

private
  def auth_params
    params.permit(:code, :provider,
                  # Twitter
                  :oauth_token, :oauth_verifier)
  end

end