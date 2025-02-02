require 'swagger_helper'
require 'rails_helper'

RSpec.describe 'States API', type: :request do
  before(:each) do
    states_response = File.read(Rails.root.join('spec', 'fixtures', 'states_responses', 'get_all_states_response.json'))
    stub_request(:get, "https://utah-aba-finder-api-c9d143f02ce8.herokuapp.com/api/v1/states")
      .to_return(
        status: 200,
        body: states_response,
        headers: { 'Content-Type' => 'application/json' }
      )
  end

  path '/api/v1/states' do
    get('list states') do
      tags 'States'
      produces 'application/json'
      description 'Retrieves a list of all US states.'
      security []

      response(200, 'successful') do
        schema example: JSON.parse(File.read(Rails.root.join('spec', 'fixtures', 'states_responses', 'get_all_states_response.json')))

        run_test! do |response|
          expect(response.status).to eq(200)
          data = JSON.parse(response.body)
          
          expect(data["data"].map { |s| s["attributes"]["name"] }).to include(
            "Utah",
            "California", 
            "New York",
            "Texas",
            "Florida"
          )

          first_state = data["data"].first
          expect(first_state["type"]).to eq("State")
          expect(first_state["attributes"]).to include(
            "name",
            "abbreviation"
          )
        end
      end
    end
  end
end