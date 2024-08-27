require 'rails_helper'

describe UtahAbaFinderService do
  context "class methods" do
    context "#get_providers" do
      it "returns providers data" do
        response = UtahAbaFinderService.get_providers

        expect(response).to be_a Hash

        providers_data = response[:data]

        expect(providers_data).to be_a Array
        
        providers_data.each do |provider|
          expect(providers_data).to be_an(Hash)

          expect(providers_response).to have_key(:data)
          expect(providers_response[:data]).to be_a(Array)
          expect(providers_response[:data].size).to eq(2)
    
          expect(providers_response[:data].first).to have_key(:id)
          expect(providers_response[:data].first[:id]).to eq(active_subscription.id)
    
          expect(providers_response[:data].first[:attributes]).to have_key(:name)
          expect(providers_response[:data].first[:attributes][:name]).to a(String)
    
          expect(providers_response[:data].first[:attributes]).to have_key(:website)
          expect(providers_response[:data].first[:attributes][:website]).to a(String)
    
          expect(providers_response[:data].first[:attributes]).to have_key(:email)
          expect(providers_response[:data].first[:attributes][:email]).to a(String)
    
          expect(providers_response[:data].first[:attributes]).to have_key(:cost)
          expect(providers_response[:data].first[:attributes][:cost]).to a(String)
    
          expect(providers_response[:data].first[:attributes]).to have_key(:min_age)
          expect(providers_response[:data].first[:attributes][:min_age]).to a(Float)
    
          expect(providers_response[:data].first[:attributes]).to have_key(:max_age)
          expect(providers_response[:data].first[:attributes][:max_age]).to a(Float)
    
          expect(providers_response[:data].first[:attributes]).to have_key(:waitlist_detail)
          expect(providers_response[:data].first[:attributes][:waitlist_detail]).to a(String)
    
          expect(providers_response[:data].first[:attributes]).to have_key(:telehealth_services)
          expect(providers_response[:data].first[:attributes][:telehealth_services]).to a(String)
    
          expect(providers_response[:data].first[:attributes]).to have_key(:at_home_services)
          expect(providers_response[:data].first[:attributes][:at_home_services]).to a(String)
    
          expect(providers_response[:data].first[:attributes]).to have_key(:in_clinic_services)
          expect(providers_response[:data].first[:attributes][:in_clinic_services]).to a(String)
    
          expect(providers_response[:data].first[:attributes]).to have_key(:spanish_speakers)
          expect(providers_response[:data].first[:attributes][:spanish_speakers]).to a(String)
    
          expect(providers_response[:data].first[:attributes]).to have_key(:logo)
          expect(providers_response[:data].first[:attributes][:logo]).to a(String)
    
          expect(providers_response[:data].first[:attributes]).to have_key(:insurance)
          expect(providers_response[:data].first[:attributes][:insurance]).to a(Array)
          
          providers_response[:data].first[:attributes][:insurance].each do |insurance|
            expect(insurance).to be_a(Hash)
            expect(insurance).to have_key(:name)
            expect(insurance[:name]).to be_a(String)
          end
    
          expect(providers_response[:data].first[:attributes]).to have_key(:locations)
          expect(providers_response[:data].first[:attributes][:locations]).to a(Array)
    
          providers_response[:data].first[:attributes][:locations].each do |location|
            expect(location).to be_a(Hash)
            expect(location).to have_key(:name)
            expect(location[:name]).to be_a(String)
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
    
          expect(providers_response[:data].first[:attributes]).to have_key(:counties_served)
          expect(providers_response[:data].first[:attributes][:counties_served]).to a(Array)
    
          providers_response[:data].first[:attributes][:counties_served].each do |area_served|
            expect(area_served).to be_a(Hash)
            expect(area_served).to have_key(:counties_served)
            expect(area_served[:counties_served]).to be_a(String)
          end
        end
      end
    end
  end
end