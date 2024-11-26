require "rails_helper"

RSpec.describe "Admin Provider Requests", type: :request do
  before(:each) do
    @super_admin = User.create!(email: "admin@test.com", password: "password", role: :super_admin)
    @non_admin = User.create!(email: "user@test.com", password: "password", role: :provider_admin)
    @admin_params = {
      "user": {
        "email": "admin@test.com",
        "password": "password"
      }
    }

    post "/login", params: @admin_params.to_json, headers: { 'Content-Type': 'application/json', "Accept": "application/json" }
    @bearer_token = response.headers["authorization"]
  end

  context "DELETE /api/v1/admin/providers/:id" do
    it "deletes a provider when requested by a super admin" do
      provider_id = 133

      # Mock external API for provider deletion
      stub_request(:delete, "https://utah-aba-finder-api-c9d143f02ce8.herokuapp.com/api/v1/providers/#{provider_id}")
        .to_return(status: 204)

      delete "/api/v1/admin/providers/#{provider_id}", headers: { 'authorization': @bearer_token }

      expect(response).to be_successful
      expect(response.status).to eq(204)
    end

    it "returns unauthorized when a non-admin user tries to delete a provider" do
      provider_id = 133

      # Simulate non-admin login
      post "/login", params: {
        "user": {
          "email": "user@test.com",
          "password": "password"
        }
      }.to_json, headers: { 'Content-Type': 'application/json', "Accept": "application/json" }

      non_admin_token = response.headers["authorization"]

      delete "/api/v1/admin/providers/#{provider_id}", headers: { 'authorization': non_admin_token }

      expect(response.status).to eq(401)
      expect(JSON.parse(response.body)).to include("error" => "Unauthorized")
    end

    it "returns error when the provider ID is invalid" do
      invalid_provider_id = 133

      # Mock external API for invalid provider deletion
      stub_request(:delete, "https://utah-aba-finder-api-c9d143f02ce8.herokuapp.com/api/v1/providers/#{invalid_provider_id}")
        .to_return(status: 404, body: { error: "Provider not found" }.to_json)

      delete "/api/v1/admin/providers/#{invalid_provider_id}", headers: { 'authorization': @bearer_token }

      expect(response.status).to eq(404)
      response_body = JSON.parse(response.body, symbolize_names: true)
      expect(response_body[:error]).to eq("Provider not found")
    end
  end
end