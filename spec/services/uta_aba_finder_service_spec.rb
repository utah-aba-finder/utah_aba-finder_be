require 'rails_helper'

RSpec.describe UtahAbaFinderService do
  context "class methods" do
    context "#get_providers" do
      it "returns providers data" do
        response = UtahAbaFinderService.get_providers

        expect(response).to be_a Hash

        providers_data = response[:data]
# binding.pry
        expect(providers_data).to be_a Array
        
        providers_data.each do |provider|
          expect(provider).to be_an(Hash)

          expect(provider).to have_key(:id)
          expect(provider[:id]).to be_a(Integer)
    
          expect(provider[:attributes]).to have_key(:name)
          expect(provider[:attributes][:name]).to be_a(String)
    
          expect(provider[:attributes]).to have_key(:website)
          expect(provider[:attributes][:website]).to be_a(String)
    
          expect(provider[:attributes]).to have_key(:email)
    
          expect(provider[:attributes]).to have_key(:cost)
    
          expect(provider[:attributes]).to have_key(:min_age)
    
          expect(provider[:attributes]).to have_key(:max_age)
    
          expect(provider[:attributes]).to have_key(:waitlist)
    
          expect(provider[:attributes]).to have_key(:telehealth_services)
    
          expect(provider[:attributes]).to have_key(:at_home_services)
    
          expect(provider[:attributes]).to have_key(:in_clinic_services)
    
          expect(provider[:attributes]).to have_key(:spanish_speakers)
    
          # expect(provider[:attributes]).to have_key(:logo)
          # expect(provider[:attributes][:logo]).to be_a(String)
    
          expect(provider[:attributes]).to have_key(:insurance)
          expect(provider[:attributes][:insurance]).to be_a(Array)
          
          provider[:attributes][:insurance].each do |insurance|
            expect(insurance).to be_a(Hash)
            expect(insurance).to have_key(:name)
            expect(insurance[:name]).to be_a(String)
          end
    
          expect(provider[:attributes]).to have_key(:locations)
          expect(provider[:attributes][:locations]).to be_a(Array)
    
          provider[:attributes][:locations].each do |location|
            expect(location).to be_a(Hash)
            expect(location).to have_key(:name)
            expect(location).to have_key(:address_1)
            expect(location).to have_key(:address_2)
            expect(location).to have_key(:city)
            expect(location).to have_key(:state)
            expect(location).to have_key(:zip)
            expect(location).to have_key(:phone)
          end
    
          expect(provider[:attributes]).to have_key(:counties_served)
          expect(provider[:attributes][:counties_served]).to be_a(Array)
    
          provider[:attributes][:counties_served].each do |area_served|
            expect(area_served).to be_a(Hash)
            expect(area_served).to have_key(:county)
          end
        end
      end
    end
  end
end