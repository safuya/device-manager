class GroupController < ApplicationController
  get '/groups' do
    only_admins
    @groups = Group.all
    erb :'groups/index'
  end

  get '/groups/new' do
    only_admins
    @users = User.all
    @devices = Device.all
    erb :'groups/new'
  end

  post '/groups' do
    only_admins
    group = Group.new(params[:group])
    group.device_ids = params[:device_ids]
    group.save
    params[:user_ids].each do |id|
      user = User.find(id)
      user.group_id = group.id
      user.save(validate: false)
    end
    redirect "/groups/#{group.id}"
  end

  get '/groups/:id' do
    only_admins
    @group = Group.find(params[:id])
    @users = @group.users
    @devices = @group.devices
    erb :'groups/show'
  end

  get '/groups/:id/edit' do
    only_admins
    @group = Group.find(params[:id])
    @users = User.all
    @devices = Device.all
    erb :'groups/edit'
  end

  patch '/groups/:id' do
    only_admins
    group = Group.find(params[:id])
    group.update(params[:group])
    redirect "/groups/#{group.id}"
  end

  delete '/groups/:id' do
    only_admins
    group = Group.find(params[:id])
    group.delete
    redirect '/groups'
  end
end
