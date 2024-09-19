require "rails_helper"

RSpec.describe "Providers Requests", type: :request do
  context "get /api/v1/providers" do
    it "returns all providers with provider attributes" do
      WebMock.disable!

      get "/api/v1/providers"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      providers_response = JSON.parse(response.body, symbolize_names: true)

      expect(providers_response).to be_an(Hash)

      expect(providers_response).to have_key(:data)
      expect(providers_response[:data]).to be_a(Array)
      expect(providers_response[:data].size).to eq(60)

      expect(providers_response[:data][5]).to have_key(:id)
      expect(providers_response[:data][5][:id]).to be_a(Integer)

      expect(providers_response[:data][5][:attributes]).to have_key(:name)
      expect(providers_response[:data][5][:attributes][:name]).to be_a(String)

      expect(providers_response[:data][5][:attributes]).to have_key(:website)
      expect(providers_response[:data][5][:attributes][:website]).to be_a(String)

      expect(providers_response[:data][5][:attributes]).to have_key(:email)
      expect(providers_response[:data][5][:attributes][:email]).to be_a(String)

      expect(providers_response[:data][5][:attributes]).to have_key(:cost)
      expect(providers_response[:data][5][:attributes][:cost]).to be_a(String).or be_nil

      expect(providers_response[:data][5][:attributes]).to have_key(:min_age)
      expect(providers_response[:data][5][:attributes][:min_age]).to be_a(Float)

      expect(providers_response[:data][5][:attributes]).to have_key(:max_age)
      expect(providers_response[:data][5][:attributes][:max_age]).to be_a(Float)

      expect(providers_response[:data][5][:attributes]).to have_key(:waitlist)
      expect(providers_response[:data][5][:attributes][:waitlist]).to be_a(String)

      expect(providers_response[:data][5][:attributes]).to have_key(:telehealth_services)
      expect(providers_response[:data][5][:attributes][:telehealth_services]).to be_a(String).or be_nil

      expect(providers_response[:data][5][:attributes]).to have_key(:at_home_services).or be_nil

      expect(providers_response[:data][5][:attributes]).to have_key(:in_clinic_services).or be_nil

      expect(providers_response[:data][5][:attributes]).to have_key(:spanish_speakers)
      expect(providers_response[:data][5][:attributes][:spanish_speakers]).to be_a(String).or be_nil

      expect(providers_response[:data][5][:attributes]).to have_key(:logo)
      expect(providers_response[:data][5][:attributes][:logo]).to be_a(String).or be_nil

      expect(providers_response[:data][5][:attributes]).to have_key(:insurance)
      expect(providers_response[:data][5][:attributes][:insurance]).to be_a(Array)
      
      providers_response[:data][5][:attributes][:insurance].each do |insurance|
        expect(insurance).to have_key(:name)
        expect(insurance[:name]).to be_a(String)
        expect(insurance).to have_key(:accepted) 
        expect(insurance[:accepted]).to be(true)
      end

      expect(providers_response[:data][5][:attributes]).to have_key(:locations)
      expect(providers_response[:data][5][:attributes][:locations]).to be_a(Array)

      providers_response[:data][5][:attributes][:locations].each do |location|
        expect(location).to be_a(Hash)
        expect(location).to have_key(:name)
        expect(location).to have_key(:address_1)
        expect(location[:address_1]).to be_a(String)
        expect(location).to have_key(:address_2)
        expect(location[:address_2]).to be_a(String)
        expect(location).to have_key(:city)
        expect(location[:city]).to be_a(String)
        expect(location).to have_key(:state)
        expect(location[:state]).to be_a(String)
        expect(location).to have_key(:zip)
        expect(location[:zip]).to be_a(String)
        expect(location).to have_key(:phone)
        expect(location[:phone]).to be_a(String)
      end

      expect(providers_response[:data][5][:attributes]).to have_key(:counties_served)
      expect(providers_response[:data][5][:attributes][:counties_served]).to be_a(Array)

      providers_response[:data][5][:attributes][:counties_served].each do |area_served|
        expect(area_served).to be_a(Hash)
        expect(area_served).to have_key(:county)
        expect(area_served[:county]).to be_a(String)
      end
    end
  end
end