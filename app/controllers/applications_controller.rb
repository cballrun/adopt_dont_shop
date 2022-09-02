class ApplicationsController < ApplicationController
  def show
    @application = Application.find(params[:id])
  end

  def new
    @application = Application.new
  end

  def create
    @application = Application.new(application_params)
    if @application.save
      redirect_to "/applications/#{@application.id}"
    else
      render :new
    end
  end

  def update
    application = Application.find(params[:id])
    if application.update(application_params)
      flash[:success] = "YOU DID IT!"
    else
      flash[:error] = "The following problems prevented us from saving your application:\n#{application.errors.full_messages.to_sentence}"
    end
    redirect_to "/applications/#{application.id}"
  end

  def application_params
    params.permit(:id, :name, :street_address, :city, :state, :zip_code, :description)
  end

end
