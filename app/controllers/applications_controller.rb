class ApplicationsController < ApplicationController
  def show
    @application = Application.find(params[:id])
  end

  def new

  end

  def create
    application = Application.create(application_params)
    redirect_to "/applications/#{application.id}"
  end

  def application_params
    params.permit(:id, :name, :street_address, :city, :state, :zip_code, :description)
  end


end
