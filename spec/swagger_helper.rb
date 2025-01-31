# frozen_string_literal: true

require 'rails_helper'

RSpec.configure do |config|
  # Specify a root folder where Swagger JSON files are generated
  # NOTE: If you're using the rswag-api to serve API descriptions, you'll need
  # to ensure that it's configured to serve Swagger from the same folder
  config.openapi_root = Rails.root.join('swagger').to_s

  # Define one or more Swagger documents and provide global metadata for each one
  # When you run the 'rswag:specs:swaggerize' rake task, the complete Swagger will
  # be generated at the provided relative path under openapi_root
  # By default, the operations defined in spec files are added to the first
  # document below. You can override this behavior by adding a openapi_spec tag to the
  # the root example_group in your specs, e.g. describe '...', openapi_spec: 'v2/swagger.json'
  config.openapi_specs = {
    'v1/swagger.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'Autism Service Locator API',
        version: 'v1',
        description: 'API Documentation with built-in test mode for write operations'
      },
      components: {
        securitySchemes: {
          bearer_auth: {
            type: :http,
            scheme: :bearer,
            bearerFormat: :JWT,
            description: 'To get an authentication token:
1. Create a User: POST /api/v1/users
2. Or login: POST /api/v1/users/sign_in
3. Copy the token from the Authorization header in the response
4. Click "Authorize" above and paste your token

Note: Do not include "Bearer" - it will be added automatically'
          }
        }
      },
      paths: {},
      servers: [
        {
          url: 'https://uta-aba-finder-be-97eec9f967d0.herokuapp.com/',
          description: 'Production Server (Write operations are protected)'
        },
        {
          url: 'http://localhost:3000',
          description: 'Local Development Server'
        }
      ],
      security: [
        { bearer_auth: [] }
      ]
    }
  }

  # Specify the format of the output Swagger file when running 'rswag:specs:swaggerize'.
  # The openapi_specs configuration option has the filename including format in
  # the key, this may want to be changed to avoid putting yaml in json files.
  # Defaults to json. Accepts ':json' and ':yaml'.
  config.openapi_format = :yaml
end