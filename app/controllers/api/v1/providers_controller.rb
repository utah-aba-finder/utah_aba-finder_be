class Api::V1::ProvidersController < ApplicationController
  before_action :authenticate_user!
  def index
    # binding.pry
    render json: UtahAbaFinderService.get_providers
  end

end