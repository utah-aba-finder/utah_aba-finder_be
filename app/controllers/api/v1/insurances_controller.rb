class Api::V1::InsurancesController < ApplicationController
  def index
    render json: UtahAbaFinderService.get_all_insurances
  end
end