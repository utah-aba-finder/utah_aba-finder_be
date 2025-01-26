require 'swagger_helper'
require 'rails_helper'

RSpec.describe 'Providers API', type: :request do
  let(:auth_token) do
    user = create(:user, email: "swagger@email.com", password: "password", provider_id: 40, role: 1)
    post '/login', params: { user: { email: user.email, password: user.password } }
    response.headers['Authorization']
  end
  # Mocking the GET request to the microservice for the /providers endpoint
  before(:each) do
    providers_response = File.read(Rails.root.join('spec', 'fixtures', 'provider_responses', 'get_all_providers_response.json'))
    # Mock the response from the microservice
    stub_request(:get, "https://utah-aba-finder-api-c9d143f02ce8.herokuapp.com/api/v1/providers")
      .to_return(
        status: 200,
        body: providers_response,
        headers: { 'Content-Type' => 'application/json' }
      )

    single_provider_response = File.read(Rails.root.join('spec', 'fixtures', 'provider_responses', 'get_provider_by_id_response.json'))
    # Stub the request to the microservice
    stub_request(:get, "https://utah-aba-finder-api-c9d143f02ce8.herokuapp.com/api/v1/providers/40")
      .to_return(
        status: 200,
        body: single_provider_response,
        headers: { 'Content-Type' => 'application/json' }
      )

    # Mock an unauthorized response for invalid token
    stub_request(:get, "https://utah-aba-finder-api-c9d143f02ce8.herokuapp.com/api/v1/providers")
    .with(headers: { 'Authorization' => 'Bearer invalid_token' })
    .to_return(
      status: 401,
      body: { error: 'Unauthorized' }.to_json,
      headers: { 'Content-Type' => 'application/json' }
    )

  @auth_token = "mocked_jwt_token"
  allow_any_instance_of(ApplicationController).to receive(:authenticate_user!).and_return(true)
  allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(User.new(id: 1, email: "test@example.com", provider_id: 40))
  end

  path '/api/v1/providers' do
    get('list providers') do
      tags 'Providers'
      produces 'application/json'
      description 'Retrieves a list of providers where their status is approved.'
      security []

      # Define the response structure
      response(200, 'successful') do
        # Define the expected JSON schema for the response
        schema type: :object, properties: {
          data: {
            type: :array, items: {
              type: :object, properties: {
                id: { type: :integer },
                type: { type: :string },
                states: { type: :array, items: { type: :string } },
                attributes: {
                  type: :object, properties: {
                    name: { type: :string },
                    provider_type: {
                      type: :array, items: {
                        type: :object, properties: {
                          id: { type: :integer },
                          name: { type: :string }
                        }
                      }
                    },
                    locations: {
                      type: :array, items: {
                        type: :object, properties: {
                          id: { type: :integer },
                          name: { type: :string },
                          address_1: { type: :string },
                          address_2: { type: :string, nullable: true },
                          city: { type: :string },
                          state: { type: :string },
                          zip: { type: :string },
                          phone: { type: :string }
                        }
                      }
                    },
                    website: { type: :string },
                    email: { type: :string },
                    cost: { type: :string },
                    insurance: {
                      type: :array, items: {
                        type: :object, properties: {
                          id: { type: :integer },
                          name: { type: :string },
                          accepted: { type: :boolean }
                        }
                      }
                    },
                    counties_served: {
                      type: :array, items: {
                        type: :object, properties: {
                          county_id: { type: :integer },
                          county_name: { type: :string }
                        }
                      }
                    },
                    min_age: { type: :number, nullable: true },
                    max_age: { type: :number, nullable: true },
                    waitlist: { type: :string, nullable: true },
                    telehealth_services: { type: :string, nullable: true },
                    spanish_speakers: { type: :string, nullable: true },
                    at_home_services: { type: :string, nullable: true },
                    in_clinic_services: { type: :string, nullable: true },
                    logo: { type: :string, nullable: true },
                    updated_last: { type: :string, format: 'date-time' },
                    status: { type: :string }
                  }
                }
              }
            }
          }
        }
      
        # Additional response validation
        run_test! do |response|
          expect(response.body).to include('Kyo Autism Therapy')
          expect(response.body).to include('Autism Solutions')
          expect(response.body).to include('Child Development and Neuropsychology Center')
          expect(response.body).to include('Sandstone Autism Services')
          expect(response.body).to include('Conestoga Behavioral Services')
        end
      end
    end
  end

  path '/api/v1/providers/{id}' do
    get('get provider by ID') do
      tags 'Providers'
      produces 'application/json'
      description 'Retrieves a single provider by their ID. Requires User login with authorization to access that providers info.'
      security [bearer_auth: []]
  
      # Define the required path parameter
      parameter name: :id, in: :path, type: :integer, description: 'ID of the provider'
      let(:id) {40}

      let(:Authorization) { "Bearer valid_token" }

      response(200, 'successful') do
        # Define the expected schema for the response
        schema type: :object, properties: {
          data: {
            type: :array, items: {
              type: :object, properties: {
                id: { type: :integer },
                type: { type: :string },
                states: { type: :array, items: { type: :string } },
                attributes: {
                  type: :object, properties: {
                    name: { type: :string },
                    provider_type: {
                      type: :array, items: {
                        type: :object, properties: {
                          id: { type: :integer },
                          name: { type: :string }
                        }
                      }
                    },
                    locations: {
                      type: :array, items: {
                        type: :object, properties: {
                          id: { type: :integer },
                          name: { type: :string },
                          address_1: { type: :string },
                          address_2: { type: :string, nullable: true },
                          city: { type: :string },
                          state: { type: :string },
                          zip: { type: :string },
                          phone: { type: :string }
                        }
                      }
                    },
                    website: { type: :string },
                    email: { type: :string },
                    cost: { type: :string },
                    insurance: {
                      type: :array, items: {
                        type: :object, properties: {
                          id: { type: :integer },
                          name: { type: :string },
                          accepted: { type: :boolean }
                        }
                      }
                    },
                    counties_served: {
                      type: :array, items: {
                        type: :object, properties: {
                          county_id: { type: :integer },
                          county_name: { type: :string }
                        }
                      }
                    },
                    min_age: { type: :number, nullable: true },
                    max_age: { type: :number, nullable: true },
                    waitlist: { type: :string, nullable: true },
                    telehealth_services: { type: :string, nullable: true },
                    spanish_speakers: { type: :string, nullable: true },
                    at_home_services: { type: :string, nullable: true },
                    in_clinic_services: { type: :string, nullable: true },
                    logo: { type: :string, nullable: true },
                    updated_last: { type: :string, format: 'date-time' },
                    status: { type: :string }
                  }
                }
              }
            }
          }
        }

        # Additional response validation
        run_test! do |response|
          # Rails.logger.info "Response status: #{response.status}"
          expect(response.status).to eq(200)
          data = JSON.parse(response.body)
          # Rails.logger.info "Provider data: #{data}"
          expect(data["data"].first['id']).to eq(40)
          expect(data["data"].first["attributes"]['name']).to eq('Kyo Autism Therapy')
        end

        response(401, 'unauthorized') do
          let(:id) { 0 }
          let(:Authorization) { 'Bearer invalid_token' }
    
          # Ensure this request uses the invalid token
          before do
            allow_any_instance_of(ApplicationController).to receive(:authenticate_user!).and_return(false)
          end

          # Define the schema for the unauthorized response
          schema type: :object, properties: {
            error: { type: :string, example: 'Unauthorized' }
          }
    
          run_test! do |response|
            expect(response.status).to eq(401)
            expect(JSON.parse(response.body)).to eq({ "error" => "Unauthorized" })
          end
        end
      end
    end
  end
end