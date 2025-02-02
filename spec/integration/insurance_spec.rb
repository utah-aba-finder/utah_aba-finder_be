require 'swagger_helper'

RSpec.describe 'Insurances API', type: :request do
  before(:each) do
    insurances_response = File.read(Rails.root.join('spec', 'fixtures', 'insurance_responses', 'get_all_insurances_response.json'))
    stub_request(:get, "https://utah-aba-finder-api-c9d143f02ce8.herokuapp.com/api/v1/insurances")
      .to_return(
        status: 200,
        body: insurances_response,
        headers: { 'Content-Type' => 'application/json' }
      )
  end

  path '/api/v1/insurances' do
    get('list insurances') do
      tags 'Insurances'
      produces 'application/json'
      description 'Retrieves a list of all insurance providers.'
      security []

      response(200, 'successful') do
        schema example: JSON.parse(File.read(Rails.root.join('spec', 'fixtures', 'insurance_responses', 'get_all_insurances_response.json')))

        run_test! do |response|
          expect(response.status).to eq(200)
          data = JSON.parse(response.body)
          
          expect(data["data"].map { |i| i["attributes"]["name"] }).to include(
            "Aetna",
            "Blue Cross Blue Shield (BCBS)",
            "Cigna",
            "Medicaid",
            "Medicare"
          )

          first_insurance = data["data"].first
          expect(first_insurance["type"]).to eq("insurance")
          expect(first_insurance["attributes"]).to have_key("name")
        end
      end
    end
  end
end