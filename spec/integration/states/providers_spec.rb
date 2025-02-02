require 'swagger_helper'
require 'rails_helper'

RSpec.describe 'State Providers API', type: :request do
  before(:each) do
    state_providers_response = File.read(Rails.root.join('spec', 'fixtures', 'provider_responses', 'get_all_utah_aba_providers_response.json'))

    stub_request(:get, "https://utah-aba-finder-api-c9d143f02ce8.herokuapp.com/api/v1/states/1/providers")
      .with(query: { provider_type: "ABA Therapy" })
      .to_return(
        status: 200,
        body: state_providers_response,
        headers: { 'Content-Type' => 'application/json' }
      )

    # For later. Stub for state not found
    stub_request(:get, "https://utah-aba-finder-api-c9d143f02ce8.herokuapp.com/api/v1/states/999/providers")
      .with(query: { provider_type: "ABA Therapy" })
      .to_return(
        status: 404,
        body: { error: 'State not found' }.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )

    # For later. Stub for invalid provider type
    stub_request(:get, "https://utah-aba-finder-api-c9d143f02ce8.herokuapp.com/api/v1/states/1/providers")
      .with(query: { provider_type: "Invalid Type" })
      .to_return(
        status: 400,
        body: { error: 'Invalid provider type. Must be one of: ABA Therapy, Autism Evaluation, Speech Therapy, Occupational Therapy' }.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )
  end

  path '/api/v1/states/{state_id}/providers' do
    get('list providers by state') do
      tags 'Providers'
      produces 'application/json'
      description 'Retrieves a list of providers for a specific state filtered by provider type. 
                  Provider type is required and MUST be one of: ABA Therapy, Autism Evaluation, 
                  Speech Therapy, or Occupational Therapy.'
      security []

      parameter name: :state_id, 
                in: :path, 
                type: :integer, 
                required: true,
                description: 'ID of the state',
                example: 1

      parameter name: :provider_type,
                in: :query,
                type: :string,
                required: true,
                description: 'Type of provider service. Must be one of the following: ABA Therapy, Autism Evaluation, Speech Therapy, Occupational Therapy',
                example: 'ABA Therapy'

      let(:state_id) { 1 }
      let(:provider_type) { 'ABA Therapy' }

      response(200, 'successful') do
        schema example: JSON.parse(File.read(Rails.root.join('spec', 'fixtures', 'provider_responses', 'get_all_utah_aba_providers_response.json')))

        run_test! do |response|
          expect(response.status).to eq(200)
          data = JSON.parse(response.body)
          
          provider = data["data"].first
          expect(provider["type"]).to eq("provider")
          expect(provider["attributes"]).to include(
            "name",
            "provider_type",
            "locations",
            "website",
            "email"
          )

          expect(data["data"].all? do |p| 
            p["attributes"]["provider_type"].any? { |t| t["name"] == "ABA Therapy" }
          end).to be true
        end
      end

      # save for later. need to add error handling in microservice
      # response(404, 'state not found') do
      #   let(:state_id) { 999 }
        
      #   schema type: :object,
      #         properties: {
      #           error: { type: :string }
      #         },
      #         example: {
      #           error: "State not found"
      #         }
        
      #   run_test! do |response|
      #     expect(response.status).to eq(404)
      #     expect(JSON.parse(response.body)).to eq({ "error" => "State not found" })
      #   end
      # end
    end
  end
end