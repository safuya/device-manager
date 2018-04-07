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

    if group.errors.any?
      errors_to_flash(group.errors.messages)
      redirect '/groups/new'
    end

    if params.key?(:user_ids)
      params[:user_ids].each do |id|
        user = User.find(id)
        user.group_id = group.id
        user.save(validate: false)
      end
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

    if group.errors.any?
      errors_to_flash(group.errors.messages)
      redirect "/groups/#{params[:group][:id]}/edit"
    end

    if params[:user_ids]
      params[:user_ids].each do |id|
        user = User.find(id)
        user.group_id = group.id
        user.save(validate: false)
      end
    else
      group.user_ids = []
      group.save
    end

    redirect "/groups/#{group.id}"
  end

  delete '/groups/:id' do
    only_admins
    group = Group.find(params[:id])
    group.delete
    redirect '/groups'
  end
end
