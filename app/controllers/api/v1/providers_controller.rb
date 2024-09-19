class Api::V1::ProvidersController < ApplicationController
  before_action :authenticate_user!, only: [:show]
  
  # to verify authentication is working, currently only functioning provider endpoint
  def index
    render json: UtahAbaFinderService.get_providers
  end

  def show
    if authenticate_user_provider_id
      render json: UtahAbaFinderService.get_provider(params[:id])
    else
      render json: {error: "Unauthorized"}, status: :unauthorized
    end
  end

  private

  def authenticate_user_provider_id
    if current_user && current_user.provider_id == params[:id].to_i
      true
    else
      false
    end
  end
end