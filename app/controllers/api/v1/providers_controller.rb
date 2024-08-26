class ProviderController < ApplicationController
  def index
    render json: UtahAbaFinderService.get_providers
  end
end