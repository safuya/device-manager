class UserController < ApplicationController
  get '/users' do
    only_admins
    @users = User.all
    erb :'users/index'
  end

  get '/users/approval' do
    only_admins
    @approvals = User.where(group_id: nil)
    @groups = Group.all
    erb :'users/approval'
  end

  patch '/users/approval' do
    if params.key?(:group)
      user = User.find(params[:user])
      user.group_id = params[:group]
      if user.save
        session[:flash] = 'User validated'
      else
        errors_to_flash(user.errors.messages)
      end
    else
      session[:flash] = 'User needs to be added to a group for approval'
    end
    redirect '/users/approval'
  end

  get '/users/:id' do
    only_current_user_or_admin
    @user = User.find(params[:id])
    erb :'users/show'
  end

  patch '/users/:id' do
    only_current_user
    user = User.find(params[:id])
    if user && user.authenticate(params[:current_password]) && user.update(params[:user])
      session[:flash] = 'Profile updated'
    else
      session[:flash] = 'Failed to update profile'
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
    if user
      user.delete
      session[:flash] = 'User deleted'
    else
      session[:flash] = 'User not found'
    end
    redirect '/users'
  end
end
