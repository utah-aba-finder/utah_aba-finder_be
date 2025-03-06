# README
# Utah ABA Finder BE
<h2> This API manages the retrieval and delivery of Autism Service Provider information, while also handling authentication and permissions for the Autism Services Locator frontend application. It is built to simplify the search for Autism services in the United States, helping parents, caregivers, and professionals to efficiently locate providers that best match their unique requirements and objectives.</h2>

## Table of Contents
- [Setup](#setup)
- [Endpoints](#endpoints)
- [Contributors](#contributors)
- [Fair Use](#fair-use)

## Setup

These instructions will help you set up and run the project on your local machine for development and testing purposes.

### Prerequisites

Ensure you have the following software installed:

- Ruby 3.2.x
- Rails 7.x
- PostgreSQL

This application is an requires the use of an API microservice to function.
Follow the Setup for the [utah_aba_finder_api](https://github.com/utah-aba-finder/utah-aba-finder-api).

### Installing

Follow these steps to set up the development environment:

Fork and Clone the repository: 

    git clone git@github.com:utah-aba-finder/utah_aba-finder_be.git

Install dependencies by running this in the terminal:

    bundle install

Set up the database by running these commands in the terminal:

    rails db:create
    rails db:migrate
    rails db:seed


Run the server in the terminal:

    rails server

Now you can access the API using another application or [Postman](https://www.postman.com/)

## API Documentation
The API is documented using OpenAPI/Swagger. You can access the interactive API documentation at:

- Local Development: http://localhost:3000/api-docs
- Production: https://uta-aba-finder-be-97eec9f967d0.herokuapp.com/api-docs/index.html

The Swagger UI provides:

- Interactive endpoint testing
- Request/response examples
- Authentication requirements
- Schema definitions
- Test mode for write operations

### Test Mode
When accessing the API through Swagger UI, write operations (POST, PUT, PATCH, DELETE) are automatically intercepted and run in test mode unless running on localhost. This means:

- No actual changes are made to the database
- You receive example responses that match the expected format
- You can safely test the API without affecting production data

### Endpoints
All endpoints return data in JSON format. The base URLs are:

- Development: http://localhost:3000
- Production: https://uta-aba-finder-be-97eec9f967d0.herokuapp.com/

### Public Endpoints

- GET /api/v1/providers - List all providers
- GET /api/v1/states - List all states
- GET /api/v1/states/:state_id/counties - List counties for a state
- GET /api/v1/insurances - List all insurances

### Protected Endpoints
These endpoints require authentication:

- GET /api/v1/providers/:id - Get specific provider details
- PATCH /api/v1/providers/:id - Update provider information
- POST /api/v1/admin/providers - Create new provider (Admin only)
- POST /api/v1/admin/insurances - Create new insurance (Admin only)

### Development Environment Test Users
When setting up your local environment, the seed data includes two test users:

1. Provider Admin User:
```
email: "test@test.com"
password: "password"
provider_id: 61
role: "provider_admin"
```
2. Super Admin User:
```
email: "testadmin@test.com"
password: "password"
role: "super_admin"
```
These users can be used to test different permission levels and functionality in your local environment. Provider admins can only access and modify their own provider's information, while super admins have access to all providers.

Note: These are test credentials and should only be used in your local development environment.
### Authentication
The API uses JWT (JSON Web Token) authentication. To authenticate:

1. Register a user:

POST /signup
Content-Type: application/json
```
{
  "user": {
    "email": "user@example.com",
    "password": "password123",
    "password_confirmation": "password123",
    "provider_id": "61",
    "role": "provider_admin"
  }
}
```
2. Login to receive a JWT token:

POST /login
Content-Type: application/json

```
{
  "user": {
    "email": "user@example.com",
    "password": "password123"
  }
}
```

3. Use the JWT token in subsequent requests:
```
Authorization: Bearer <your_jwt_token>
```

## Related Links & Repositories
- [Utah ABA Finder API Repository](https://github.com/utah-aba-finder/utah-aba-finder-api)
- [Utah ABA Finder BE Repository](https://github.com/utah-aba-finder/utah_aba-finder_be)
- [Utah ABA Finder FE Repository](https://github.com/utah-aba-finder/utah-aba-finder-fe)
- [Deployed Applications in PRD](https://utahabalocator.com/)

## Contributors
- [Austin Carr Jones](https://github.com/austincarrjones)
- [Chee_Lee](https://github.com/cheeleertr)
- [Jordan Williamson](https://github.com/JWill06)
- [Kevin Nelson](https://github.com/kevinm23nelson)
- [Mel Langhoff](https://github.com/mel-langhoff)
- [Seong Kang](https://github.com/sanghoro)

## Fair Use
### Utah ABA Finder BE is free and open to use. Because of this, we humbly ask developers to use it fairly. This is a service to aid parents, caregivers, and professionals.
