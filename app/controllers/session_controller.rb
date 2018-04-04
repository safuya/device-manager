class SessionController < ApplicationController
  get '/' do
    flash('Account not approved') unless approved?
    redirect '/devices' if logged_in?
    erb :'sessions/index'
  end

  post '/login' do
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
    else
      flash('Failed to log in')
    end
    redirect '/'
  end

  get '/signout' do
    session.clear
    redirect '/'
  end

  get '/apply' do
    erb :'sessions/apply'
  end

  post '/apply' do
    user = User.create(params[:user])
    session[:user_id] = user.id
    redirect '/'
  end
end
