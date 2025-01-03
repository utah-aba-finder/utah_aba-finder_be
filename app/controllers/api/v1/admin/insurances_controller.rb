class Api::V1::Admin::InsurancesController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_super_admin

  def show
      render json: UtahAbaFinderService.get_all_insurances(params[:id])
  end

  def create
      render json: UtahAbaFinderService.create_insurance(params)
  end

  def update
      render json: UtahAbaFinderService.update_insurance(params[:id], params)
  end

  private

  def authenticate_super_admin
    unless current_user && current_user.super_admin?
      render json: { error: "Unauthorized" }, status: :unauthorized
    end
  end
end