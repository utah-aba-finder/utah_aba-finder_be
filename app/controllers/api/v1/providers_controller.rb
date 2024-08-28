class Api::V1::ProvidersController < ApplicationController
  def index
    render json: UtahAbaFinderService.get_providers
  end
end