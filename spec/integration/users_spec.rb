require 'swagger_helper'

RSpec.describe 'User API', type: :request do
  path '/signup' do
    post 'Registers a new user' do
      tags 'Users'
      consumes 'application/json'
      produces 'application/json'
      security []

      parameter name: :user, in: :body, required: true, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              email: { type: :string, format: :email, example: 'user@example.com' },
              password: { type: :string, format: :password, example: 'password123', minLength: 6 },
              password_confirmation: { type: :string, format: :password, example: 'password123', minLength: 6 },
              provider_id: { type: :string, example: '61' }
            },
            required: ['email', 'password', 'password_confirmation']
          }
        }
      }

      request_body_example value: {
        user: {
          email: 'user@example.com',
          password: 'password123',
          password_confirmation: 'password123',
          # refactor this when id assignment is updated
          provider_id: '61 (ID Will be currently set to nil by default at this time)'
        }
      }, name: 'User registration example', summary: 'Example parameters for user registration request'

      response '200', 'User successfully registered' do
        header 'Authorization', schema: { 
          type: :string,
          description: 'JWT Bearer token for user authorization'
        }

        schema type: :object,
          properties: {
            status: {
              type: :object,
              properties: {
                code: { type: :integer, example: 200 },
                message: { type: :string, example: 'Signed up successfully.' }
              },
              required: ['code', 'message']
            },
            data: {
              type: :object,
              properties: {
                id: { type: :integer, example: 1 },
                email: { type: :string, format: :email, example: 'user@example.com' },
                created_at: { type: :string, format: 'date-time' },
                provider_id: { type: :string, nullable: true, example: '61' },
                role: { type: :string, enum: ['super_admin', 'provider_admin'], example: 'provider_admin' },
                created_date: { type: :string, example: '01/01/2025' }
              },
              required: ['id', 'email', 'created_at', 'role']
            }
          },
          required: ['status', 'data']

        let(:valid_attributes) do
          {
            email: 'user@example.com',
            password: 'password123',
            password_confirmation: 'password123',
            provider_id: '61'
          }
        end

        let(:user) { { user: valid_attributes } }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(response).to have_http_status(:ok)
          expect(data['status']).to include(
            'code' => 200,
            'message' => 'Signed up successfully.'
          )
          expect(data['data']).to include(
            'email' => valid_attributes[:email],
            'role' => 'provider_admin'
          )
          expect(data['data']['id']).to be_an(Integer)
          expect(data['data']['created_at']).to be_present
          expect(data['data']['created_date']).to be_present
          expect(data['data']['provider_id']).to be_nil
          expect(response.headers['Authorization']).to be_present
          expect(response.headers['Authorization']).to match(/^Bearer .+/)
        end
      end

      response '422', 'User registration failed' do
        schema type: :object,
        properties: {
          status: {
            type: :object,
            properties: {
              code: { type: :integer, example: 422 },
              message: { type: :string, example: "User couldn't be created successfully." }
            },
            required: ['code', 'message']
          }
        }

        context 'with empty parameters' do
          let(:user) { { user: { email: '', password: '', password_confirmation: '' } } }

          run_test! do |response|
            data = JSON.parse(response.body)
            expect(response).to have_http_status(:unprocessable_entity)
            expect(data['status']['code']).to eq(422)
            expect(data['status']['message']).to include("User couldn't be created successfully. Email can't be blank and Password can't be blank")
          end
        end

        context 'with mismatched passwords' do
          let(:user) do
            { 
              user: {
                email: 'user@example.com',
                password: 'password123',
                password_confirmation: 'different_password',
                provider_id: '61'
              }
            }
          end
      
          run_test! do |response|
            data = JSON.parse(response.body)
            expect(response).to have_http_status(:unprocessable_entity)
            expect(data['status']['code']).to eq(422)
            expect(data['status']['message']).to include("Password confirmation doesn't match Password")
          end
        end
      
        context 'with invalid email format' do
          let(:user) do
            {
              user: {
                email: 'invalid_email',
                password: 'password123',
                password_confirmation: 'password123',
                provider_id: '61'
              }
            }
          end
      
          run_test! do |response|
            data = JSON.parse(response.body)
            expect(response).to have_http_status(:unprocessable_entity)
            expect(data['status']['code']).to eq(422)
            expect(data['status']['message']).to include("User couldn't be created successfully. Email is invalid")
          end
        end

        context 'with duplicate email' do
          before do
            User.create!(
              email: 'existing@example.com',
              password: 'password123',
              password_confirmation: 'password123',
              provider_id: '61'
            )
          end
      
          let(:user) do
            {
              user: {
                email: 'existing@example.com',
                password: 'password123',
                password_confirmation: 'password123',
                provider_id: '61'
              }
            }
          end
      
          run_test! do |response|
            data = JSON.parse(response.body)
            expect(response).to have_http_status(:unprocessable_entity)
            expect(data['status']['code']).to eq(422)
            expect(data['status']['message']).to include("Email has already been taken")
          end
        end
      end
    end
  end

  path '/login' do
    post 'Logs in a user and returns a JWT token' do
      tags 'Users'
      consumes 'application/json'
      produces 'application/json'
      security []

      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              email: { type: :string, example: 'test@example.com' },
              password: { type: :string, example: 'password123' }
            },
            required: ['email', 'password']
          }
        }
      }

      request_body_example value: {
        user: {
          email: 'test@example.com',
          password: 'password123'
        }
      }, name: 'User login example', summary: 'Example parameters for user login request'

      response '200', 'Login successful' do
        header 'Authorization', schema: { type: :string }, 
          description: 'JWT token in Bearer format'

        schema type: :object,
          properties: {
            status: {
              type: :object,
              properties: {
                code: { type: :integer, example: 200 },
                message: { type: :string, example: 'Logged in successfully' }
              }
            },
            data: {
              type: :object,
              properties: {
                id: { type: :integer, example: 1 },
                email: { type: :string, format: :email, example: 'test@example.com' },
                created_at: { type: :string, format: 'date-time' },
                provider_id: { type: :integer, nullable: true, example: 61 },
                role: { type: :string, example: 'provider_admin' }
              }
            }
          }

        let(:user_password) { 'password123' }
        let!(:existing_user) do
          User.create!(
            email: 'test@example.com',
            password: user_password,
            password_confirmation: user_password,
            role: 'provider_admin',
            provider_id: 61
          )
        end

        let(:user) do
          {
            user: {
              email: existing_user.email,
              password: user_password
            }
          }
        end

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(response).to have_http_status(:ok)
          expect(data['status']['code']).to eq(200)
          expect(data['status']['message']).to eq('Logged in successfully')
          
          expect(data['data']['email']).to eq(existing_user.email)
          expect(data['data']['id']).to eq(existing_user.id)
          expect(data['data']['role']).to eq('provider_admin')
          expect(data['data']['provider_id']).to eq(61)
          
          expect(response.headers['Authorization']).to be_present
          expect(response.headers['Authorization']).to start_with('Bearer ')
        end
      end

      response '401', 'Invalid login credentials' do
        let(:user) do
          {
            user: {
              email: 'wrong@example.com',
              password: 'wrongpassword'
            }
          }
        end

        schema type: :object,
          properties: {
            status: {
              type: :object,
              properties: {
                error: { type: :string, example: 'Invalid Email or password.' }
              }
            }
          }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(response).to have_http_status(:unauthorized)
          expect(data['error']).to eq('Invalid Email or password.')
        end
      end
    end
  end
end