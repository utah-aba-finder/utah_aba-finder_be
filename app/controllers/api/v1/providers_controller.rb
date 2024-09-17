class Api::V1::ProvidersController < ApplicationController
  # before_action :authenticate_user!
  # to verify authentication is working, currently only functioning provider endpoint
  def index
    render json: UtahAbaFinderService.get_providers
  end
end