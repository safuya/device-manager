class GroupController < ApplicationController
  get '/groups' do
    @groups = Group.all
    erb :'groups/index'
  end

  get '/groups/new' do
    @users = User.all
    @devices = Device.all
    erb :'groups/new'
  end

  post '/groups' do
    group = Group.new(params[:group])
    group.device_ids = params[:device_ids]
    group.save
    params[:user_ids].each do |id|
      user = User.find(id)
      user.group_id = id
      user.save(validate: false)
    end
    redirect "/groups/#{group.id}"
  end

  get '/groups/:id' do
    @group = Group.find(params[:id])
    @users = @group.users
    @devices = @group.devices
    erb :'groups/show'
  end

  get '/groups/:id/edit' do
    @group = Group.find(params[:id])
    @users = User.all
    @devices = Device.all
    erb :'groups/edit'
  end

  patch '/groups/:id' do
    group = Group.find(params[:id])
    group.update(params[:group])
    redirect "/groups/#{group.id}"
  end

  delete '/groups/:id' do
    group = Group.find(params[:id])
    group.delete
    redirect '/groups'
  end
end
