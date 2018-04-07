class SessionController < ApplicationController
  get '/' do
    session[:flash] = 'You require approval' if not_approved?
    redirect '/devices' if approved?
    erb :'sessions/index'
  end

  post '/login' do
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
    else
      session[:flash] = 'Failed to log in'
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
    user = User.new(params[:user])
    if user.save
      session[:user_id] = user.id
    else
      errors_to_flash(user.errors.messages)
      session[:flash] = 'Account not created.' + session[:flash]
    end
    redirect '/'
  end
end
