class Api::V1::Admin::ProvidersController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_super_admin

  def index
    render json: UtahAbaFinderService.get_providers_for_admin
  end

  def show
    render json: UtahAbaFinderService.get_provider(params[:id])
  end

  def create
    render json: UtahAbaFinderService.create_provider(params)
  end

  def update
    render json: UtahAbaFinderService.update_provider(params[:id], params)
  end

  def destroy
    provider_id = params[:id]
    response = UtahAbaFinderService.delete_provider(provider_id)
    if response.success?
      head :no_content
    else
      render json: { error: "Provider not found" }, status: :not_found
    end
  end

  private

  def authenticate_super_admin
    unless current_user && current_user.super_admin?
      render json: { error: "Unauthorized" }, status: :unauthorized
    end
  end
end