require 'swagger_helper'
require 'rails_helper'

RSpec.describe 'Admin Insurances API', type: :request do
  let(:auth_token) do
    user = create(:user, email: "admin@email.com", password: "password", role: 0) # super_admin role
    post '/login', params: { user: { email: user.email, password: user.password } }
    response.headers['Authorization']
  end

  before(:each) do
    create_insurance_response = {
      data: [{
        id: 999,
        type: "insurance",
        attributes: {
          name: "Example Insurance Provider"
        }
      }]
    }.to_json

    stub_request(:post, "https://utah-aba-finder-api-c9d143f02ce8.herokuapp.com/api/v1/insurances")
      .to_return(
        status: 201,
        body: create_insurance_response,
        headers: { 'Content-Type' => 'application/json' }
      )

    update_insurance_response = {
      data: [{
        id: 1,
        type: "insurance",
        attributes: {
          name: "Updated Insurance Provider"
        }
      }]
    }.to_json

    stub_request(:patch, "https://utah-aba-finder-api-c9d143f02ce8.herokuapp.com/api/v1/insurances/999")
      .to_return(
        status: 200,
        body: update_insurance_response,
        headers: { 'Content-Type' => 'application/json' }
      )

      stub_request(:delete, "https://utah-aba-finder-api-c9d143f02ce8.herokuapp.com/api/v1/insurances/999")
      .to_return(
        status: 200,
        body: {
          message: "Insurance 'Example Insurance Provider' successfully deleted"
        }.to_json,
        headers: { 'Content-Type': 'application/json' }
      )

    # Error scenarios
    stub_request(:patch, "https://utah-aba-finder-api-c9d143f02ce8.herokuapp.com/api/v1/insurances/9999")
      .to_return(
        status: 404,
        body: { error: 'Unauthorized' }.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )

    stub_request(:delete, "https://utah-aba-finder-api-c9d143f02ce8.herokuapp.com/api/v1/insurances/9999")
      .to_return(
        status: 404,
        body: { error: 'Unauthorized' }.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )


    @auth_token = "mocked_jwt_token"
    allow_any_instance_of(ApplicationController).to receive(:authenticate_user!).and_return(true)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(User.new(id: 1, email: "admin@example.com", role: 0))
  end

  path '/api/v1/admin/insurances' do
    post('create insurance') do
      tags 'Admin Insurances'
      consumes 'application/json'
      produces 'application/json'
      description 'Creates a new insurance. Requires super_admin role.'
      security [bearer_auth: []]

      parameter name: 'Authorization', in: :header, type: :string, required: true
      
      parameter name: :insurance, in: :body, schema: {
        type: :object,
        properties: {
          data: {
            type: :array,
            items: {
              type: :object,
              properties: {
                # type: { type: :string },
                attributes: {
                  type: :object,
                  properties: {
                    name: { type: :string, example: 'Example Insurance Provider' }
                  },
                  required: ['name']
                }
              }
            }
          }
        }
      }

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
                  attributes: {
                    type: :object,
                    properties: {
                      name: { type: :string }
                    }
                  }
                }
              }
            }
          }

        schema example: JSON.parse(File.read(Rails.root.join('spec', 'fixtures', 'insurance_responses', 'single_insurance_response.json')))


        let(:Authorization) { "Bearer #{auth_token}" }
        let(:insurance) { {
          data: [{
            type: "insurance",
            attributes: {
              name: "Example Insurance Provider"
            }
          }]
        } }

        run_test! do |response|
          expect(response.status).to eq(200)
          data = JSON.parse(response.body)
          expect(data["data"].first["attributes"]["name"]).to eq("Example Insurance Provider")
        end
      end

      response(401, 'unauthorized') do
        let(:Authorization) { 'Bearer invalid_token' }
        before do
          allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(User.new(id: 1, email: "admin@example.com", role: 1))
        end

        let(:insurance) { {
          data: [{
            type: "insurance",
            attributes: {
              name: "Test Insurance"
            }
          }]
        } }
        
        schema type: :object,
          properties: {
            error: { type: :string, example: 'Unauthorized' }
          }

        run_test! do |response|
          expect(response.status).to eq(401)
          expect(JSON.parse(response.body)).to eq({ "error" => "Unauthorized" })
        end
      end
    end
  end

  path '/api/v1/admin/insurances/{id}' do
    parameter name: :id, in: :path, type: :integer, required: true,
              description: 'ID of the insurance'

    patch('update insurance') do
      tags 'Admin Insurances'
      consumes 'application/json'
      produces 'application/json'
      description 'Updates an existing insurance. Requires super_admin role.'
      security [bearer_auth: []]

      parameter name: 'Authorization', in: :header, type: :string, required: true
      
      parameter name: :insurance, in: :body, schema: {
        type: :object,
        properties: {
          data: {
            type: :array,
            items: {
              type: :object,
              properties: {
                id: { type: :integer, example: 999 },
                type: { type: :string },
                attributes: {
                  type: :object,
                  properties: {
                    name: { type: :string, example: 'Example Insurance Provider'}
                  },
                  required: ['name']
                }
              }
            }
          }
        }
      }

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
                  attributes: {
                    type: :object,
                    properties: {
                      name: { type: :string }
                    }
                  }
                }
              }
            }
          }
        schema example: JSON.parse(File.read(Rails.root.join('spec', 'fixtures', 'insurance_responses', 'single_insurance_response.json')))

        let(:id) { 999 }
        let(:Authorization) { "Bearer #{auth_token}" }
        let(:insurance) { {
          data: [{
            id: 1,
            type: "insurance",
            attributes: {
              name: "Updated Insurance Provider"
            }
          }]
        } }

        run_test! do |response|
          expect(response.status).to eq(200)
          data = JSON.parse(response.body)
          expect(data["data"].first["attributes"]["name"]).to eq("Updated Insurance Provider")
        end
      end

      response(401, 'unauthorized') do
        let(:id) { 9999 }
        let(:Authorization) { 'Bearer invalid_token' }
        before do
          allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(User.new(id: 1, email: "admin@example.com", role: 1))
        end

        let(:insurance) { {
          data: [{
            id: 999,
            type: "insurance",
            attributes: {
              name: "Test Insurance"
            }
          }]
        } }
        
        schema type: :object,
          properties: {
            error: { type: :string, example: 'Unauthorized' }
          }

        run_test! do |response|
          expect(response.status).to eq(401)
          expect(JSON.parse(response.body)).to eq({ "error" => "Unauthorized" })
        end
      end
    end

    delete('delete insurance') do
      tags 'Admin Insurances'
      produces 'application/json'
      description 'Deletes an insurance. Requires super_admin role.'
      security [bearer_auth: []]

      parameter name: 'Authorization', in: :header, type: :string, required: true,
                example: 999

      response(200, 'successful') do
        schema type: :object,
              properties: {
                message: { type: :string }
              },
              example: {
                message: "Insurance 'Example Insurance Provider' successfully deleted"
              }
    
        let(:id) { 999 }
        let(:Authorization) { "Bearer #{auth_token}" }

        run_test! do |response|
          expect(response.status).to eq(200)
          data = JSON.parse(response.body)
          expect(data["message"]).to eq("Insurance 'Example Insurance Provider' successfully deleted")
        end
      end

      response(401, 'unauthorized') do
        let(:id) { 9999 }
        let(:Authorization) { 'Bearer invalid_token' }
        before do
          allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(User.new(id: 1, email: "admin@example.com", role: 1))
        end
        
        schema type: :object,
          properties: {
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