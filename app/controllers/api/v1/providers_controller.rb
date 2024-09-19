class Api::V1::ProvidersController < ApplicationController
  # before_action :authenticate_user!

  def index
    render json: UtahAbaFinderService.get_providers
  end

  def show
    render json: UtahAbaFinderService.get_provider(params[:id])
  end

  def update
    id = params[:id]
    render json: UtahAbaFinderService.update_provider(id, params)
  end

end