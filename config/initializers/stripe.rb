Stripe.api_key = ENV['STRIPE_API_KEY'] || Rails.application.credentials.dig(:stripe, :test_secret_key)

Stripe.api_version = '2022-11-15' # Use the latest Stripe API version
