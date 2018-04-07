class DeviceController < ApplicationController
  get '/devices' do
    only_approved
    @devices = Device.all
    erb :'devices/index'
  end

  get '/devices/new' do
    only_admins
    @groups = Group.all
    erb :'devices/new'
  end

  post '/devices' do
    only_admins
    device = Device.new(params[:device])
    device.save
    unless device.errors.blank?
      errors_to_flash(device.errors.messages)
      redirect '/devices/new'
    end
    redirect "/devices/#{device.id}"
  end

  get '/devices/:id' do
    only_approved
    @device = Device.find(params[:id])
    unauthorized unless @device.groups.include?(current_user.group)
    @groups = @device.groups
    erb :'devices/show'
  end

  get '/devices/:id/edit' do
    only_admins
    @device = Device.find(params[:id])
    @groups = Group.all
    erb :'devices/edit'
  end

  patch '/devices/:id' do
    only_admins
    device = Device.find(params[:id])
    errors_to_flash(device.errors.messages) unless device.update(params[:device])
    redirect "/devices/#{device.id}"
  end

  delete '/devices/:id' do
    only_admins
    device = Device.find(params[:id])
    device.delete
    redirect '/devices'
  end
end
