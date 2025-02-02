# Be sure to restart your server when you modify this file.

# Avoid CORS issues when API is called from the frontend app.
# Handle Cross-Origin Resource Sharing (CORS) in order to accept cross-origin Ajax requests.

# Read more: https://github.com/cyu/rack-cors

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins "utahabalocator.com", 
            "autismserviceslocator.com",
            "https://uta-aba-finder-be-97eec9f967d0.herokuapp.com",  # Your Heroku domain
            /\Ahttps?:\/\/localhost:\d+\z/ # This covers all localhost ports

    resource "*",
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head],
      expose: ["Authorization"],
      credentials: true
  end
end
