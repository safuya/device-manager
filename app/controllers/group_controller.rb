class GroupController < ApplicationController
  get '/groups' do
    @groups = Group.all
    erb :'groups/index'
  end

  get '/groups/new' do
    erb :'groups/new'
  end

  post '/groups' do
    group = Group.new(params[:group])
    group.save
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
    @users = @group.users
    @devices = @group.devices
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
