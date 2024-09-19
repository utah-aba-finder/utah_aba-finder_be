class Api::V1::ProvidersController < ApplicationController
  # before_action :authenticate_user!
  # to verify authentication is working, currently only functioning provider endpoint
  def index
    render json: UtahAbaFinderService.get_providers
  end

  def show
    render json: UtahAbaFinderService.get_provider(params[:id])
  end

  def update
    id = params[:id]
    provider_data = request.raw_post # Capturing the raw JSON body from the PATCH request
    render json: UtahAbaFinderService.update_provider(id, provider_data)
  end
end