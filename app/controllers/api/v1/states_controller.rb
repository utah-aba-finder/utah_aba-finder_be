class Api::V1::StatesController < ApplicationController
  def index
    render json: UtahAbaFinderService.get_states
  end
end