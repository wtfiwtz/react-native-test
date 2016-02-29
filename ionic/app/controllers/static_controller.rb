class StaticController < ApplicationController
  skip_before_action :require_login
  skip_authorization_check only: [:apply, :availability, :calendar, :details, :profile, :register, :search, :settings,
                                  :signup, :venue]
end
