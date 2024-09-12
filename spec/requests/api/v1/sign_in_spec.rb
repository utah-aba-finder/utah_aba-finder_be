require "rails_helper"

RSpec.describe "User Sign-Up", type: :request do
  it 'creates a new user and associates them with a provider' do
    sign_up_params = {
      user: {
        email: 'new_provider@example.com',
        password: 'password',
        password_confirmation: 'password',
        provider_name: 'Provider ABC'
      }
    }

    post '/api/v1/signup', params: sign_up_params

    expect(response).to have_http_status(:created)

    user = User.find_by(email: 'new_provider@example.com')
    expect(user.provider_id).to eq(123)
  end
end