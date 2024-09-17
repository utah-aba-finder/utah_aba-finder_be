class Api::V1::ProvidersController < ApplicationController
  def index
    render json: UtahAbaFinderService.get_providers
  end

  def show
    render json: UtahAbaFinderService.get_provider(params[:id])
  end
end