class UserController < ApplicationController
  get '/users' do
    @users = User.all
    erb :'users/index'
  end

  get '/users/:id' do
    @user = User.find(params[:id])
    erb :'users/show'
  end

  patch '/users/:id' do
    user = User.find(params[:id])
    user.update(params[:user])
    redirect "/user/#{user.id}"
  end

  get '/users/:id/edit' do
    @user = User.find(params[:id])
    @groups = Group.all
    erb :'users/edit'
  end
end
