require './config/environment'
require './app/helpers/authorization'
require './app/helpers/flash'

class ApplicationController < Sinatra::Base
  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, ENV['session_secret']
  end

  helpers Flash, Authorization
end
