require 'rails_helper'

RSpec.describe 'User Login' do
  before(:each) do
    user = User.create!(email: "test@test.com", password: "password")
  end
  context "login/logout" do
    it "user can login with credentials" do
      user_params = {
        "user": {
          "email": "test@test.com",
          "password": "password"
        }
      }

      post "/login", params: user_params.to_json, headers: { 'Content-Type': 'application/json', "Accept": "application/json" }

      expect(response).to be_successful
      expect(response.status).to eq(200)
  
      login_response = JSON.parse(response.body, symbolize_names: true)

      bearer_token = response.headers["authorization"].split(" ").last

      expect(bearer_token).to be_a(String)

      expect(login_response).to have_key(:status)
      expect(login_response[:status]).to be_a(Hash)

      expect(login_response[:status]).to have_key(:code)
      expect(login_response[:status][:code]).to be_a(Integer)

      expect(login_response[:status]).to have_key(:message)
      expect(login_response[:status][:message]).to be_a(String)

      expect(login_response).to have_key(:data)
      expect(login_response[:data]).to be_a(Hash)

      expect(login_response[:data]).to have_key(:id)
      expect(login_response[:data][:id]).to be_a(Integer)

      expect(login_response[:data]).to have_key(:email)
      expect(login_response[:data][:email]).to be_a(String)
      
      expect(login_response[:data]).to have_key(:created_at)
      expect(login_response[:data][:created_at]).to be_a(String)

      expect(login_response[:data]).to have_key(:created_date)
      expect(login_response[:data][:created_date]).to be_a(String)
    end

    it "user can logout when signed in" do
      user_params = {
        "user": {
          "email": "test@test.com",
          "password": "password"
        }
      }

      post "/login", params: user_params.to_json, headers: { 'Content-Type': 'application/json', "Accept": "application/json" }

      bearer_token = response.headers["authorization"]
      
      delete "/logout", headers: { 'authorization': bearer_token }

      expect(response).to be_successful
      expect(response.status).to eq(200)

      logout_response = JSON.parse(response.body, symbolize_names: true)
      expect(logout_response[:message]).to eq("logged out successfully")
    end

    it "user cannot logout without bearer_token" do
      user_params = {
        "user": {
          "email": "test@test.com",
          "password": "password"
        }
      }

      post "/login", params: user_params.to_json, headers: { 'Content-Type': 'application/json', "Accept": "application/json" }

      bearer_token = response.headers["authorization"]
      
      delete "/logout", headers: { 'authorization': '' }

      logout_response = JSON.parse(response.body, symbolize_names: true)

      expect(logout_response[:status]).to eq(401)
      expect(logout_response[:message]).to eq("Couldn't find an active session.")
    end

    it "user cannot logout without bearer_token" do
      user_params = {
        "user": {
          "email": "test@test.com",
          "password": "password"
        }
      }

      post "/login", params: user_params.to_json, headers: { 'Content-Type': 'application/json', "Accept": "application/json" }

      bearer_token = response.headers["authorization"]
      
      delete "/logout", headers: { 'authorization': '' }

      logout_response = JSON.parse(response.body, symbolize_names: true)

      expect(logout_response[:status]).to eq(401)
      expect(logout_response[:message]).to eq("Couldn't find an active session.")
    end


  end
end