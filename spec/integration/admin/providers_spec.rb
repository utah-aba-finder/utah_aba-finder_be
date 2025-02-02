require 'swagger_helper'
require 'rails_helper'

RSpec.describe 'Admin Providers API', type: :request do
  let(:auth_token) do
    user = create(:user, email: "admin@email.com", password: "password", role: 0) # super_admin role
    post '/login', params: { user: { email: user.email, password: user.password } }
    response.headers['Authorization']
  end

  before(:each) do
    admin_providers_response = File.read(Rails.root.join('spec', 'fixtures', 'provider_responses', 'get_all_admin_providers_response.json'))
    stub_request(:get, "https://utah-aba-finder-api-c9d143f02ce8.herokuapp.com/api/v1/admin/providers")
      .to_return(
        status: 200,
        body: admin_providers_response,
        headers: { 'Content-Type' => 'application/json' }
      )

    single_provider_response = File.read(Rails.root.join('spec', 'fixtures', 'provider_responses', 'get_provider_by_id_response.json'))
    stub_request(:get, "https://utah-aba-finder-api-c9d143f02ce8.herokuapp.com/api/v1/providers/61")
      .to_return(
        status: 200,
        body: single_provider_response,
        headers: { 'Content-Type' => 'application/json' }
      )

    create_provider_response = File.read(Rails.root.join('spec', 'fixtures', 'provider_responses', 'create_provider_response.json'))
    stub_request(:post, "https://utah-aba-finder-api-c9d143f02ce8.herokuapp.com/api/v1/providers")
      .to_return(
        status: 200,
        body: create_provider_response,
        headers: { 'Content-Type' => 'application/json' }
      )

    update_provider_response = File.read(Rails.root.join('spec', 'fixtures', 'provider_responses', 'update_provider_by_id_response.json'))
    stub_request(:patch, "https://utah-aba-finder-api-c9d143f02ce8.herokuapp.com/api/v1/providers/61")
      .to_return(
        status: 200,
        body: update_provider_response,
        headers: { 'Content-Type' => 'application/json' }
      )

    # Error scenarios
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

    @auth_token = "mocked_jwt_token"
    allow_any_instance_of(ApplicationController).to receive(:authenticate_user!).and_return(true)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(User.new(id: 1, email: "admin@example.com", role: 0))
  end

  path '/api/v1/admin/providers' do
    get('list all providers') do
      tags 'Admin Providers'
      produces 'application/json'
      description 'Retrieves a list of all providers regardless of status. Requires super_admin role.'
      security [bearer_auth: []]

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
                            name: { type: [:string, :null] },
                            address_1: { type: [:string, :null] },
                            address_2: { type: [:string, :null] },
                            city: { type: [:string, :null] },
                            state: { type: [:string, :null] },
                            zip: { type: [:string, :null] },
                            phone: { type: [:string, :null] }
                          }
                        }
                      },
                      website: { type: [:string, :null] },
                      email: { type: [:string, :null] },
                      cost: { type: [:string, :null] },
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
                      min_age: { type: [:number, :null] },
                      max_age: { type: [:number, :null] },
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

          schema example: File.read(Rails.root.join('spec', 'fixtures', 'provider_responses', 'get_all_admin_providers_response.json'))

        let(:Authorization) { "Bearer #{auth_token}" }

        run_test! do |response|
          expect(response.status).to eq(200)
          data = JSON.parse(response.body)
          expect(data["data"]).to be_an(Array)
        end
      end

      response(401, 'unauthorized') do
        let(:Authorization) { 'Bearer invalid_token' }

        before do
          allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(User.new(id: 1, email: "admin@example.com", role: 1))
        end

        schema type: :object,
              properties: {
                error: { type: :string }
              }

        run_test! do |response|
          expect(response.status).to eq(401)
          expect(JSON.parse(response.body)).to eq({ "error" => "Unauthorized" })
        end
      end
    end

    post('create provider') do
      tags 'Admin Providers'
      consumes 'application/json'
      produces 'application/json'
      description 'Creates a new provider. Requires super_admin role.'
      security [bearer_auth: []]
      
      parameter name: :provider, in: :body, schema: {
        type: :object,
        properties: {
          data: {
            type: :array,
            items: {
              type: :object,
              properties: {
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
                          name: { type: :string },
                          address_1: { type: :string },
                          address_2: { type: :string },
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
                    min_age: { type: :number },
                    max_age: { type: :number },
                    waitlist: { type: :string },
                    telehealth_services: { type: :string },
                    spanish_speakers: { type: :string },
                    at_home_services: { type: :string },
                    in_clinic_services: { type: :string },
                    logo: { type: :string },
                    status: { type: :string }
                  },
                  required: ['name', 'email']
                }
              }
            }
          }
        }
      }

      let(:Authorization) { "Bearer #{auth_token}" }
      let(:provider) { {
        data: [{
          type: "provider",
          states: ["Utah"],
          attributes: {
            name: "New Provider",
            provider_type: [{
              id: 1,
              name: "ABA Therapy"
            }],
            locations: [{
              name: "Main Office",
              address_1: "123 Main St",
              city: "Salt Lake City",
              state: "Utah",
              zip: "84111",
              phone: "801-555-0123"
            }],
            website: "https://www.newprovider.com",
            email: "info@newprovider.com",
            cost: "Varies",
            insurance: [{
              id: 1,
              name: "Blue Cross",
              accepted: true
            }],
            counties_served: [{
              county_id: 1,
              county_name: "Salt Lake"
            }],
            min_age: 2,
            max_age: 18,
            waitlist: "No",
            telehealth_services: "Yes",
            spanish_speakers: "Yes",
            status: "pending"
          }
        }]
      } }

      response(200, 'provider created') do
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
                                name: { type: [:string, :null] },
                                address_1: { type: [:string, :null] },
                                address_2: { type: [:string, :null] },
                                city: { type: [:string, :null] },
                                state: { type: [:string, :null] },
                                zip: { type: [:string, :null] },
                                phone: { type: [:string, :null] }
                              }
                            }
                          },
                          website: { type: [:string, :null] },
                          email: { type: [:string, :null] },
                          cost: { type: [:string, :null] },
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
                          min_age: { type: [:number, :null] },
                          max_age: { type: [:number, :null] },
                          waitlist: { type: [:string, :null] },
                          telehealth_services: { type: [:string, :null] },
                          spanish_speakers: { type: [:string, :null] },
                          at_home_services: { type: [:string, :null] },
                          in_clinic_services: { type: [:string, :null] },
                          logo: { type: [:string, :null] },
                          updated_last: { type: [:string, :null], format: 'date-time' },
                          status: { type: [:string, :null] }
                        }
                      }
                    }
                  }
                }
              }

        run_test! do |response|
          expect(response.status).to eq(200)
          data = JSON.parse(response.body)
          expect(data["data"].first["attributes"]["name"]).to eq("Example Creation")
          expect(data["data"].first["states"]).to eq(["Utah"])
        end
      end

      response(401, 'unauthorized') do
        let(:Authorization) { 'Bearer invalid_token' }
        before do
          allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(User.new(id: 1, email: "admin@example.com", role: 1))
        end
        
        schema type: :object,
              properties: {
                error: { type: :string, example: "Unauthorized" }
              }

        run_test! do |response|
          expect(response.status).to eq(401)
          expect(JSON.parse(response.body)).to eq({ "error" => "Unauthorized" })
        end
      end
    end
  end

  path '/api/v1/admin/providers/{id}' do
    get('get provider by ID') do
      tags 'Admin Providers'
      produces 'application/json'
      description 'Retrieves a single provider by their ID. Requires super_admin role.'
      security [bearer_auth: []]

      parameter name: :id, 
          in: :path, 
          type: :integer, 
          description: 'ID of the provider',
          example: 61,
          required: true

      let(:id) { 61 }
      let(:Authorization) { "Bearer #{auth_token}" }

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
          expect(data["data"].first["id"]).to eq(61)
          expect(data["data"].first["attributes"]["name"]).to eq("Kyo Autism Therapy")
        end
      end

      response(401, 'unauthorized') do
        let(:Authorization) { 'Bearer invalid_token' }
        before do
          allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(User.new(id: 1, email: "admin@example.com", role: 1))
        end
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

    end

    patch('update provider') do
      tags 'Admin Providers'
      consumes 'application/json'
      produces 'application/json'
      description 'Updates an existing provider. Requires super_admin role.'
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
        before do
          allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(User.new(id: 1, email: "admin@example.com", role: 1))
        end
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
