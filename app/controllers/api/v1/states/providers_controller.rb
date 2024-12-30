class Api::V1::States::ProvidersController < ApplicationController
  def index
    render json: UtahAbaFinderService.get_providers_by_state_id(params[:state_id], params[:provider_type])
  end
end