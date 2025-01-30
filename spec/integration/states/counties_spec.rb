require 'swagger_helper'
require 'rails_helper'

RSpec.describe 'Counties API', type: :request do
  before(:each) do
    counties_response = File.read(Rails.root.join('spec', 'fixtures', 'counties_responses', 'get_all_utah_counties_response.json'))
    stub_request(:get, "https://utah-aba-finder-api-c9d143f02ce8.herokuapp.com/api/v1/states/1/counties")
      .to_return(
        status: 200,
        body: counties_response,
        headers: { 'Content-Type' => 'application/json' }
      )
  end

  path '/api/v1/states/{state_id}/counties' do
    get('list counties') do
      tags 'Counties'
      produces 'application/json'
      description 'Retrieves a list of counties for a specific state.'
      security []

      parameter name: :state_id, 
                in: :path, 
                type: :integer, 
                required: true,
                description: 'ID of the state',
                example: 1

      let(:state_id) { 1 }

      response(200, 'successful') do
        schema example: JSON.parse(File.read(Rails.root.join('spec', 'fixtures', 'counties_responses', 'get_all_utah_counties_response.json')))

        run_test! do |response|
          expect(response.status).to eq(200)
          data = JSON.parse(response.body)
          
          expect(data["data"].map { |c| c["attributes"]["name"] }).to include(
            "Salt Lake",
            "Utah",
            "Davis",
            "Weber",
            "Cache"
          )

          first_county = data["data"].first
          expect(first_county["type"]).to eq("County")
          expect(first_county["attributes"]).to include(
            "name",
            "state"
          )

          expect(data["data"].all? { |c| c["attributes"]["state"] == "Utah" }).to be true
        end
      end
    end

    # save for later. need error handling for state not found in api
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