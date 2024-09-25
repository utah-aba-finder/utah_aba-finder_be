require "rails_helper"

RSpec.describe "Update Provider Request", type: :request do
  context "patch /api/v1/provider/:id" do
    before(:each) do

      @user = User.create!(email: "test@test.com", password: "password", provider_id: 61)
      @user_params = {
          "user": {
            "email": "test@test.com",
            "password": "password"
          }
        }

      post "/login", params: @user_params.to_json, headers: { 'Content-Type': 'application/json', "Accept": "application/json" }
      
      @bearer_token = response.headers["authorization"]

      WebMock.enable!  # Ensure WebMock is enabled only in this file or test
      stub_request(:patch, "https://utah-aba-finder-api-c9d143f02ce8.herokuapp.com/api/v1/providers/61")
    .with(
      body: "{\"data\":{\"id\":61,\"type\":\"provider\",\"attributes\":{\"name\":\"Updated Provider Name\"}},\"controller\":\"api/v1/providers\",\"action\":\"update\",\"id\":\"61\",\"provider\":{\"data\":{\"id\":61,\"type\":\"provider\",\"attributes\":{\"name\":\"Updated Provider Name\"}}}}",
      headers: {
        'Accept'=>'*/*',
        'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'Authorization'=>'be6205db57ce01863f69372308c41e3a',
        'Content-Type'=>'application/json',
        'User-Agent'=>'Faraday v2.10.0'
      }
    ).to_return(status: 200, body: { success: true }.to_json, headers: {})
    
    end
  
    after(:each) do
      WebMock.disable!  # Disable WebMock for the rest of the suite after this test
    end

    it "updates provider" do
      patch "/api/v1/providers/61", params: {
        data: {
          id: 61,
          type: "provider",
          attributes: {
            name: "Updated Provider Name"
          }
        }
      }.to_json, headers: { 'Content-Type' => 'application/json', 'authorization' => @bearer_token }

      expect(response).to be_successful
      expect(response.status).to eq(200)

      parsed_response = JSON.parse(response.body, symbolize_names: true)

      expect(parsed_response[:success]).to be true
    end

    it "returns error without bearer token" do
      get "/api/v1/providers/61"

      expect(response.status).to eq(401)
      expect(response.body).to eq("You need to sign in or sign up before continuing.")
    end

    it "returns error unauthorized if current user and provider request id don't match" do
      get "/api/v1/providers/6", headers: { 'authorization': @bearer_token }

      expect(response.status).to eq(401)

      providers_response = JSON.parse(response.body, symbolize_names: true)

      expect(providers_response[:error]).to eq("Unauthorized")
    end
  end
end