class UserController < ApplicationController
  get '/users' do
    stop_non_admins
    @users = User.all
    erb :'users/index'
  end

  get '/users/:id' do
    only_current_user_or_admin
    @user = User.find(params[:id])
    erb :'users/show'
  end

  patch '/users/:id' do
    only_current_user
    user = User.find(params[:id])
    if user && user.authenticate(params[:current_password])
      user.update(params[:user])
    end
    redirect "/users/#{user.id}"
  end

  get '/users/:id/edit' do
    only_current_user
    @user = User.find(params[:id])
    @groups = Group.all
    erb :'users/edit'
  end

  delete '/users/:id' do
    only_current_user_or_admin
    user = User.find(params[:id])
    user.delete
    redirect '/users'
  end
end
