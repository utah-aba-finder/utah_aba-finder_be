require "rails_helper"

RSpec.describe "Provider Request", type: :request do
  before(:each) do
    @user = User.create!(email: "test@test.com", password: "password", provider_id: 2)
    @user_params = {
        "user": {
          "email": "test@test.com",
          "password": "password"
        }
      }

    post "/login", params: @user_params.to_json, headers: { 'Content-Type': 'application/json', "Accept": "application/json" }
    
    @bearer_token = response.headers["authorization"]
  end

  context "get /api/v1/providers/:id" do
    it "returns one provider with provider attributes" do

      get "/api/v1/providers/2", headers: { 'authorization': @bearer_token }

      expect(response).to be_successful
      expect(response.status).to eq(200)

      providers_response = JSON.parse(response.body, symbolize_names: true)

      expect(providers_response).to be_a (Hash)

      expect(providers_response).to have_key(:data)
      expect(providers_response[:data]).to be_an(Array)
      expect(providers_response[:data].size).to eq(1)

      expect(providers_response[:data].first).to have_key(:id)
      expect(providers_response[:data].first[:id]).to be_an(Integer)

      expect(providers_response[:data].first[:attributes]).to have_key(:name)
      expect(providers_response[:data].first[:attributes][:name]).to be_a(String)

      expect(providers_response[:data].first[:attributes]).to have_key(:website)
      expect(providers_response[:data].first[:attributes][:website]).to be_a(String)

      expect(providers_response[:data].first[:attributes]).to have_key(:email)
      expect(providers_response[:data].first[:attributes][:email]).to be_a(String)

      expect(providers_response[:data].first[:attributes]).to have_key(:cost)
      expect(providers_response[:data].first[:attributes][:cost]).to be_a(String)

      expect(providers_response[:data].first[:attributes]).to have_key(:min_age)
      expect(providers_response[:data].first[:attributes][:min_age]).to be_a(Float)

      expect(providers_response[:data].first[:attributes]).to have_key(:max_age)
      expect(providers_response[:data].first[:attributes][:max_age]).to be_a(Float)

      expect(providers_response[:data].first[:attributes]).to have_key(:waitlist)
      expect(providers_response[:data].first[:attributes][:waitlist]).to be_a(String)

      expect(providers_response[:data].first[:attributes]).to have_key(:telehealth_services)
      expect(providers_response[:data].first[:attributes][:telehealth_services]).to be_a(String).or be_nil

      expect(providers_response[:data].first[:attributes]).to have_key(:at_home_services)

      expect(providers_response[:data].first[:attributes]).to have_key(:in_clinic_services)

      expect(providers_response[:data].first[:attributes]).to have_key(:spanish_speakers)
      expect(providers_response[:data].first[:attributes][:spanish_speakers]).to be_a(String).or be_nil

      expect(providers_response[:data].first[:attributes]).to have_key(:logo)
      expect(providers_response[:data].first[:attributes][:logo]).to be_a(String)

      expect(providers_response[:data].first[:attributes]).to have_key(:insurance)
      expect(providers_response[:data].first[:attributes][:insurance]).to be_an(Array)
      
      providers_response[:data].first[:attributes][:insurance].each do |insurance|
        expect(insurance).to have_key(:name)
        expect(insurance[:name]).to be_a(String)
        expect(insurance).to have_key(:accepted) 
        expect(insurance[:accepted]).to be(true)
      end

      expect(providers_response[:data].first[:attributes]).to have_key(:locations)
      expect(providers_response[:data].first[:attributes][:locations]).to be_an(Array)

      providers_response[:data].first[:attributes][:locations].each do |location|
        expect(location).to be_a(Hash)
        expect(location).to have_key(:name)
        expect(location).to have_key(:address_1)
        expect(location[:address_1]).to be_a(String).or be_nil
        expect(location).to have_key(:address_2)
        expect(location[:address_2]).to be_a(String).or be_nil
        expect(location).to have_key(:city)
        expect(location[:city]).to be_a(String).or be_nil
        expect(location).to have_key(:state)
        expect(location[:state]).to be_a(String).or be_nil
        expect(location).to have_key(:zip)
        expect(location[:zip]).to be_a(String).or be_nil
        expect(location).to have_key(:phone)
        expect(location[:phone]).to be_a(String).or be_nil
      end

      expect(providers_response[:data].first[:attributes]).to have_key(:counties_served)
      expect(providers_response[:data].first[:attributes][:counties_served]).to be_an(Array)

      providers_response[:data].first[:attributes][:counties_served].each do |area_served|
        expect(area_served).to be_a(Hash)
        expect(area_served).to have_key(:county)
        expect(area_served[:county]).to be_a(String)
      end
    end

    it "returns without bearer token" do
      get "/api/v1/providers/2"

      expect(response.status).to eq(401)
      expect(response.body).to eq("You need to sign in or sign up before continuing.")
    end

    it "returns error unauthorized if current user and provider request id don't match" do
      get "/api/v1/providers/3", headers: { 'authorization': @bearer_token }

      expect(response.status).to eq(401)

      providers_response = JSON.parse(response.body, symbolize_names: true)

      expect(providers_response[:error]).to eq("Unauthorized")
    end
  end
end