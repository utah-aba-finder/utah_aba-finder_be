require 'swagger_helper'

RSpec.describe 'User API', type: :request do
  path '/signup' do
    post 'Registers a new user' do
      tags 'Users'
      consumes 'application/json'
      produces 'application/json'
      security []
      parameter name: :user, in: :body, required: true, description: 'User registration data'

      
      response '200', 'User successfully registered' do
        # Define Header response
        header 'authorization', schema: { type: :string }, description: 'JWT to send with future requests to for user authorization.'
        # Define the expected schema for the response
        schema type: :object,
        properties: {
          status: {
            type: :object,
            properties: {
              code: {type: :integer, example: 200 },
              message: { type: :string, example: "Signed up successfully." }
            }
          },
          data: {
            type: :object,
            properties: {
              id: { type: :integer, example: 1 },
              email: { type: :string, format: :email, example: 'user@example.com' },
              created_at: { type: :string, format: 'date-time' },
              provider_id: { type: :string, nullable: true, example: '61' },
              role: { type: :string, example: "provider_admin"},
              created_date: { type: :string, example: '01/01/2025' }
            },
          }
        }

        let(:user) { { user: { email: 'user@example.com', password: 'password123', password_confirmation: 'password123', provider_id: '61' } } }
        
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(response.code).to eq("200") # Ensure the response code is 200
          expect(data['status']['code']).to eq(200)
          expect(data['status']['message']).to eq('Signed up successfully.')
          expect(data['data']['email']).to eq('user@example.com')
          expect(data['data']['id']).to be_present
          expect(data['data']['role']).to be_present
          expect(data['data']['created_at']).to be_present
          expect(data['data']['created_date']).to be_present
          expect(data['data']['provider_id']).to be_nil
          expect(response.headers['authorization']).to be_present
        end
      end

      response '422', 'User creation failed due to validation errors' do
        let(:user) { { email: '', password: '', password_confirmation: '' } } # Passing empty data to trigger validation failure

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(response.code).to eq("422") # Ensure the response code is 422 when validation fails
          expect(data['status']['code']).to eq(422)
          expect(data['status']['message']).to include("User couldn't be created successfully.")
        end
      end
    end
  end

  # path '/login' do
  #   post 'Logs in an existing user' do
  #     tags 'Users'
  #     consumes 'application/json'
  #     produces 'application/json'
  #     security []

  #     parameter name: :user, in: :body, required: true, description: 'User login data' do
  #       schema type: :object,
  #              properties: {
  #                email: { type: :string, format: :email, example: 'user@example.com' },
  #                password: { type: :string, example: 'password123' }
  #              },
  #              required: ['email', 'password']
  #     end

  #     response '200', 'User successfully logged in' do
  #       let(:user) { { email: 'user@example.com', password: 'password123' } }

  #       before do
  #         User.create(email: 'user@example.com', password: 'password123', password_confirmation: 'password123')
  #       end

  #       run_test! do |response|
  #         data = JSON.parse(response.body)
  #         expect(data['status']['code']).to eq(200)
  #         expect(data['status']['message']).to eq('Logged in successfully')
  #         expect(data['data']['email']).to eq('user@example.com')
  #         expect(data['data']['id']).to be_present
  #       end
  #     end

  #     response '401', 'Invalid credentials' do
  #       let(:user) { { email: 'user@example.com', password: 'wrongpassword' } }

  #       run_test! do |response|
  #         data = JSON.parse(response.body)
  #         expect(data['status']['code']).to eq(401)
  #         expect(data['status']['message']).to eq('Invalid credentials')
  #       end
  #     end
  #   end
  # end

  # path '/logout' do
  #   delete 'Logs out the current user' do
  #     tags 'Users'
  #     produces 'application/json'

  #     response '200', 'User successfully logged out' do
  #       let(:user) { { email: 'user@example.com', password: 'password123' } }

  #       before do
  #         user = User.create(email: 'user@example.com', password: 'password123', password_confirmation: 'password123')
  #         post '/login', params: { email: user.email, password: user.password }
  #       end

  #       run_test! do |response|
  #         data = JSON.parse(response.body)
  #         expect(data['status']).to eq(200)
  #         expect(data['message']).to eq('logged out successfully')
  #       end
  #     end

  #     response '401', 'User is not logged in' do
  #       run_test! do |response|
  #         data = JSON.parse(response.body)
  #         expect(data['status']).to eq(401)
  #         expect(data['message']).to eq("Couldn't find an active session.")
  #       end
  #     end
  #   end
  # end
end