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
    group = Group.create(params[:group])
    redirect "/groups/#{group.id}" unless group.errors.any?

    errors_to_flash(group.errors.messages)
    redirect '/groups/new'
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
    redirect "/groups/#{group.id}" unless group.errors.any?

    errors_to_flash(group.errors.messages)
    redirect "/groups/#{params[:id]}/edit"
  end

  delete '/groups/:id' do
    only_admins
    group = Group.find(params[:id])
    group.delete
    redirect '/groups'
  end
end
