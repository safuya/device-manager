class DeviceController < ApplicationController
  get '/devices' do
    @devices = Device.all
    erb :'devices/index'
  end

  get '/devices/new' do
    @groups = Group.all
    erb :'devices/new'
  end

  post '/devices' do
    device = Device.new(params[:device])
    device.save
    redirect "/devices/#{device.id}"
  end

  get '/devices/:id' do
    @device = Device.find(params[:id])
    @groups = @device.groups
    erb :'devices/show'
  end

  get '/devices/:id/edit' do
    @device = Device.find(params[:id])
    @groups = Group.all
    erb :'devices/edit'
  end

  patch '/devices/:id' do
    device = Device.find(params[:id])
    device.update(params[:device])
    redirect "/devices/#{device.id}"
  end

  delete '/devices/:id' do
    device = Device.find(params[:id])
    device.delete
    redirect '/devices'
  end
end
