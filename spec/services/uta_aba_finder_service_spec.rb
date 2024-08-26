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

          expect(providers_data).to have_key(:data)
          expect(providers_data[:data]).to be_a(Array)
          expect(providers_data[:data].size).to eq(2)
    
          expect(providers_data[:data].first).to have_key(:id)
          expect(providers_data[:data].first[:id]).to eq(active_subscription.id)
    
          expect(providers_data[:data].first[:attributes]).to have_key(:name)
          expect(providers_data[:data].first[:attributes][:name]).to a(String)
    
          expect(providers_data[:data].first[:attributes]).to have_key(:website)
          expect(providers_data[:data].first[:attributes][:website]).to a(String)
    
          expect(providers_data[:data].first[:attributes]).to have_key(:phone)
          expect(providers_data[:data].first[:attributes][:phone]).to a(String)
    
          expect(providers_data[:data].first[:attributes]).to have_key(:email)
          expect(providers_data[:data].first[:attributes][:email]).to a(String)
    
          expect(providers_data[:data].first[:attributes]).to have_key(:cost)
          expect(providers_data[:data].first[:attributes][:cost]).to a(String)
    
          expect(providers_data[:data].first[:attributes]).to have_key(:ages_served)
          expect(providers_data[:data].first[:attributes][:ages_served]).to a(String)
    
          expect(providers_data[:data].first[:attributes]).to have_key(:waitlist)
          expect(providers_data[:data].first[:attributes][:waitlist]).to a(String)
    
          expect(providers_data[:data].first[:attributes]).to have_key(:telehealth_services)
          expect(providers_data[:data].first[:attributes][:telehealth_services]).to a(String)
    
          expect(providers_data[:data].first[:attributes]).to have_key(:spanish_speakers)
          expect(providers_data[:data].first[:attributes][:spanish_speakers]).to a(String)
    
          expect(providers_data[:data].first[:attributes]).to have_key(:insurance)
          expect(providers_data[:data].first[:attributes][:insurance]).to a(Array)
          
          providers_data[:data].first[:attributes][:insurance].each do |insurance|
            expect(insurance).to be_a(Hash)
            expect(insurance).to have_key(:name)
            expect(insurance[:name]).to be_a(String)
          end
    
          expect(providers_data[:data].first[:attributes]).to have_key(:locations)
          expect(providers_data[:data].first[:attributes][:locations]).to a(Array)
    
          providers_data[:data].first[:attributes][:locations].each do |location|
            expect(location).to be_a(Hash)
            expect(location).to have_key(:name)
            expect(location[:name]).to be_a(String)
          end
    
          expect(providers_data[:data].first[:attributes]).to have_key(:areas_served)
          expect(providers_data[:data].first[:attributes][:areas_served]).to a(Array)
    
          providers_data[:data].first[:attributes][:areas_served].each do |area_served|
            expect(area_served).to be_a(Hash)
            expect(area_served).to have_key(:name)
            expect(area_served[:name]).to be_a(String)
          end
        end
      end
    end
  end
end