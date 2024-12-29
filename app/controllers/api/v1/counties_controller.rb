class Api::V1::CountiesController < ApplicationController
  def index
    render json: UtahAbaFinderService.get_counties_by_state(params[:state_id])
  end
end