class SessionController < ApplicationController
  get '/' do
    redirect '/devices' if logged_in?
    erb :'sessions/index'
  end

  post '/login' do
    user = User.find_by(username: params[:username])
    session[:user_id] = user.id if user && user.authenticate(params[:password])
    redirect '/'
  end

  get '/signout' do
    session.clear
    redirect '/'
  end
end
