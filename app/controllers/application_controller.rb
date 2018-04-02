require './config/environment'

class ApplicationController < Sinatra::Base
  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, ENV['session_secret']
  end

  helpers do
    def stop_non_admins
      halt erb :'errors/401' unless admin?
    end

    def stop_unapproved
      halt erb :'errors/401' unless approved?
    end

    def current_user
      @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
    end

    def logged_in?
      !!current_user
    end

    def admin?
      logged_in? && current_user.group.privilege == 'admin'
    end

    def approved?
      logged_in? && !current_user.group_id.blank?
    end
  end
end
