require 'swagger_helper'
require 'rails_helper'

RSpec.describe 'Providers API', type: :request do
  let(:auth_token) do
    user = create(:user, email: "swagger@email.com", password: "password", provider_id: 61, role: 1)
    post '/login', params: { user: { email: user.email, password: user.password } }
    response.headers['Authorization']
  end

  before(:each) do
    providers_response = File.read(Rails.root.join('spec', 'fixtures', 'provider_responses', 'get_all_providers_response.json'))
    stub_request(:get, "https://utah-aba-finder-api-c9d143f02ce8.herokuapp.com/api/v1/providers")
      .to_return(
        status: 200,
        body: providers_response,
        headers: { 'Content-Type' => 'application/json' }
      )

    single_provider_response = File.read(Rails.root.join('spec', 'fixtures', 'provider_responses', 'get_provider_by_id_response.json'))
    stub_request(:get, "https://utah-aba-finder-api-c9d143f02ce8.herokuapp.com/api/v1/providers/61")
      .to_return(
        status: 200,
        body: single_provider_response,
        headers: { 'Content-Type' => 'application/json' }
      )

    update_single_provider_response = File.read(Rails.root.join('spec', 'fixtures', 'provider_responses', 'update_provider_by_id_response.json'))
    stub_request(:patch, "https://utah-aba-finder-api-c9d143f02ce8.herokuapp.com/api/v1/providers/61")
      .with(
        headers: { 
          'Content-Type' => 'application/json'
        }
      )
      .to_return(
        status: 200,
        body: update_single_provider_response,
        headers: { 'Content-Type' => 'application/json' }
      )

    # Mock responses for different error scenarios
    stub_request(:get, "https://utah-aba-finder-api-c9d143f02ce8.herokuapp.com/api/v1/providers/999")
      .to_return(
        status: 404,
        body: { error: 'Provider not found' }.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )

    stub_request(:patch, "https://utah-aba-finder-api-c9d143f02ce8.herokuapp.com/api/v1/providers/999")
    .to_return(
      status: 404,
      body: { error: 'Provider not found' }.to_json,
      headers: { 'Content-Type' => 'application/json' }
    )

    stub_request(:get, "https://utah-aba-finder-api-c9d143f02ce8.herokuapp.com/api/v1/providers")
      .with(headers: { 'Authorization' => 'Bearer invalid_token' })
      .to_return(
        status: 401,
        body: { error: 'Unauthorized' }.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )

    @auth_token = "mocked_jwt_token"
    allow_any_instance_of(ApplicationController).to receive(:authenticate_user!).and_return(true)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(User.new(id: 1, email: "test@example.com", provider_id: 61))
  end

  path '/api/v1/providers' do
    get('list providers') do
      tags 'Providers'
      produces 'application/json'
      description 'Retrieves a list of providers where their status is approved.'
      security []

      response(200, 'successful') do
        schema type: :object, properties: {
          data: {
            type: :array, 
            items: {
              type: :object, 
              properties: {
                id: { type: :integer },
                type: { type: :string },
                states: { type: :array, items: { type: :string } },
                attributes: {
                  type: :object, 
                  properties: {
                    name: { type: :string },
                    provider_type: {
                      type: :array, 
                      items: {
                        type: :object, 
                        properties: {
                          id: { type: :integer },
                          name: { type: :string }
                        }
                      }
                    },
                    locations: {
                      type: :array, 
                      items: {
                        type: :object, 
                        properties: {
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
                      type: :array, 
                      items: {
                        type: :object, 
                        properties: {
                          id: { type: :integer },
                          name: { type: :string },
                          accepted: { type: :boolean }
                        }
                      }
                    },
                    counties_served: {
                      type: :array, 
                      items: {
                        type: :object, 
                        properties: {
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

        schema example: JSON.parse(File.read(Rails.root.join('spec', 'fixtures', 'provider_responses', 'get_all_providers_response.json')))

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
      
      parameter name: :id, 
                in: :path, 
                type: :integer, 
                description: 'ID of the provider',
                example: 61,
                required: true
      
      let(:id) { 61 }
      let(:Authorization) { "Bearer valid_token" }

      response(200, 'successful') do
        schema type: :object, 
              properties: {
                data: {
                  type: :array, 
                  items: {
                    type: :object, 
                    properties: {
                      id: { type: :integer },
                      type: { type: :string },
                      states: { type: :array, items: { type: :string } },
                      attributes: {
                        type: :object, 
                        properties: {
                          name: { type: :string },
                          provider_type: {
                            type: :array, 
                            items: {
                              type: :object, 
                              properties: {
                                id: { type: :integer },
                                name: { type: :string }
                              }
                            }
                          },
                          locations: {
                            type: :array, 
                            items: {
                              type: :object, 
                              properties: {
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
                            type: :array, 
                            items: {
                              type: :object, 
                              properties: {
                                id: { type: :integer },
                                name: { type: :string },
                                accepted: { type: :boolean }
                              }
                            }
                          },
                          counties_served: {
                            type: :array, 
                            items: {
                              type: :object, 
                              properties: {
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

        run_test! do |response|
          expect(response.status).to eq(200)
          data = JSON.parse(response.body)
          expect(data["data"].first['id']).to eq(61)
          expect(data["data"].first["attributes"]['name']).to eq('Kyo Autism Therapy')
        end
      end

      response(401, 'unauthorized') do
        let(:id) { 0 }
        let(:Authorization) { 'Bearer invalid_token' }

        schema type: :object, 
              properties: {
                error: { type: :string }
              },
              example: {
                error: "Unauthorized"
              }
  
        run_test! do |response|
          expect(response.status).to eq(401)
          expect(JSON.parse(response.body)).to eq({ "error" => "Unauthorized" })
        end
      end

      # save for later. need to create error handling for provider not found
      # response(404, 'provider not found') do
      #   let(:id) { 9999 }
      #   schema type: :object,
      #          properties: {
      #            error: { type: :string }
      #          },
      #          example: {
      #            error: "Provider with ID 9999 not found"
      #          }
      #   run_test!
      # end
    end

    patch('update provider') do
      tags 'Providers'
      consumes 'application/json'
      produces 'application/json'
      description 'Updates an existing provider. Requires User login with authorization to modify provider info.'
      security [bearer_auth: []]
      
      parameter name: :id, in: :path, type: :integer, required: true,
                description: 'ID of the provider to update',
                example: 61

      parameter name: :provider, in: :body, schema: {
        example: JSON.parse(File.read(Rails.root.join('spec', 'fixtures', 'provider_responses', 'update_provider_by_id_response.json')))
      }

      let(:id) { 61 }
      let(:Authorization) { "Bearer valid_token" }
      let(:provider) { {
        data: [{
          id: 61,
          type: "provider",
          state: "Utah",
          attributes: {
            name: "Example Creation",
            provider_type: [{
              id: 1,
              name: "ABA Therapy"
            }],
            locations: [{
              id: nil,
              name: "testing_grounds",
              address_1: nil,
              address_2: nil,
              city: nil,
              state: nil,
              zip: nil,
              phone: "111-111-1111"
            }],
            website: "https://www.testing.com",
            email: "info@testing.com",
            cost: "N/A",
            insurance: [{
              name: "Contact us",
              id: 1,
              accepted: true
            }],
            counties_served: [{
              county_id: 1,
              name: "Beaver"
            }, {
              county_id: 2,
              name: "Box Elder"
            }],
            min_age: 2.0,
            max_age: 16.0,
            waitlist: "No",
            telehealth_services: "Yes",
            spanish_speakers: "Yes",
            at_home_services: nil,
            in_clinic_services: nil,
            logo: "example_logo@logo.com",
            status: "pending"
          }
        }]
      } }

      response(200, 'successful') do
        schema type: :object,
              properties: {
                data: {
                  type: :array,
                  items: {
                    type: :object,
                    properties: {
                      id: { type: :integer },
                      type: { type: :string },
                      states: { 
                        type: :array,
                        items: { type: :string }
                      },
                      attributes: {
                        type: :object,
                        properties: {
                          name: { type: :string },
                          provider_type: {
                            type: :array,
                            items: {
                              type: :object,
                              properties: {
                                id: { type: :integer },
                                name: { type: :string }
                              }
                            }
                          },
                          locations: {
                            type: :array,
                            items: {
                              type: :object,
                              properties: {
                                id: { type: :integer },
                                name: { type: :string },
                                address_1: { type: [:string, :null] },
                                address_2: { type: [:string, :null] },
                                city: { type: [:string, :null] },
                                state: { type: [:string, :null] },
                                zip: { type: [:string, :null] },
                                phone: { type: :string }
                              }
                            }
                          },
                          website: { type: :string },
                          email: { type: :string },
                          cost: { type: :string },
                          insurance: {
                            type: :array,
                            items: {
                              type: :object,
                              properties: {
                                id: { type: :integer },
                                name: { type: :string },
                                accepted: { type: :boolean }
                              }
                            }
                          },
                          counties_served: {
                            type: :array,
                            items: {
                              type: :object,
                              properties: {
                                county_id: { type: :integer },
                                county_name: { type: :string }
                              }
                            }
                          },
                          min_age: { type: :number },
                          max_age: { type: :number },
                          waitlist: { type: [:string, :null] },
                          telehealth_services: { type: [:string, :null] },
                          spanish_speakers: { type: [:string, :null] },
                          at_home_services: { type: [:string, :null] },
                          in_clinic_services: { type: [:string, :null] },
                          logo: { type: [:string, :null] },
                          updated_last: { type: :string, format: 'date-time' },
                          status: { type: :string }
                        }
                      }
                    }
                  }
                }
              }
        schema example: JSON.parse(File.read(Rails.root.join('spec', 'fixtures', 'provider_responses', 'update_provider_by_id_response.json')))


        run_test! do |response|
          expect(response.status).to eq(200)
          data = JSON.parse(response.body)
          expect(data["data"].first["id"]).to eq(61)
          expect(data["data"].first["attributes"]["name"]).to eq("Example Creation")
          expect(data["data"].first["states"]).to eq(["Utah"])
        end
      end

      response(401, 'unauthorized') do
        let(:id) { 999 }
        let(:Authorization) { 'Bearer invalid_token' }
        let(:provider) { {
          data: [{
            id: 999,
            type: "provider",
            attributes: {
              name: "Test Unauthorized"
            }
          }]
        } }
        
        schema type: :object,
              properties: {
                error: { type: :string, example: "Unauthorized" }
              }
        
        run_test! do |response|
          expect(response.status).to eq(401)
          expect(JSON.parse(response.body)).to eq({ "error" => "Unauthorized" })
        end
      end

      # save for later. need to fix error handling for provider not found
      # response(404, 'provider not found') do
      #   let(:id) { 9999 }
        
      #   schema type: :object,
      #          properties: {
      #            error: { type: :string }
      #          }
        
      #   run_test!
      # end
    end
  end
end
