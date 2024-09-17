class Api::V1::ProvidersController < ApplicationController
  before_action :authenticate_user!
  def index
    render json: UtahAbaFinderService.get_providers
  end
end