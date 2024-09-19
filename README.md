# README
# Utah ABA Finder BE
<h2> This API manages the retrieval and delivery of Applied Behavior Analysis (ABA) provider information, while also handling authentication and permissions for the Utah ABA Finder frontend application. It is built to simplify the search for ABA services in Utah, helping parents, caregivers, and professionals to efficiently locate providers that best match their unique requirements and objectives.</h2>

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

## Endpoints

- **Follow Setup** to use the Rails server.
- **Change Port (Optional)**: If using the Rails server for `utah_aba_finder_api`, you will need to change the localhost port to `4000`.

  To do this:
  1. Open the file `config/puma.rb`.
  2. Find the following line:
  
      ```ruby
      port ENV.fetch("PORT") { 3000 }
      ```
      
  3. Change it to:

      ```ruby
      port ENV.fetch("PORT") { 4000 }
      ```

  Now, your Rails server will run on [http://localhost:4000](http://localhost:4000).

- **Base URL**: 
  - Default: `http://localhost:3000`
  - If running on the modified port: `http://localhost:4000`
  
- **Format**: All endpoints return data in **JSON** format.
  
### Get All Providers

**`GET /api/v1/providers`**

Retrieves a list of all ABA providers, including their details such as name, locations, services, and contact information.

#### Response Example:

```json
{
  "data": [
    {
      "id": 1,
      "type": "provider",
      "attributes": {
        "name": "A BridgeCare ABA",
        "locations": [
          {
            "name": "https://www.bridgecareaba.com/locations/aba-therapy-in-utah",
            "address_1": null,
            "address_2": null,
            "city": null,
            "state": null,
            "zip": null,
            "phone": "801-435-8088"
          }
        ],
        "website": "https://www.bridgecareaba.com/locations/utah",
        "email": "info@bridgecareaba.com",
        "cost": "N/A",
        "insurance": [
          {
            "name": "Contact us"
          }
        ],
        "counties_served": [
          {
            "county": "Salt Lake, Utah, Davis, Weber"
          }
        ],
        "min_age": 2.0,
        "max_age": 16.0,
        "waitlist": "No",
        "telehealth_services": "Yes",
        "spanish_speakers": "Yes",
        "at_home_services": null,
        "in_clinic_services": null
      }
    },
    {
      "id": 2,
      "type": "provider",
      "attributes": {
        "name": "Above & Beyond Therapy",
        "locations": [
          {
            "name": "https://www.abtaba.com/locations/aba-therapy-in-utah",
            "address_1": null,
            "address_2": null,
            "city": null,
            "state": null,
            "zip": null,
            "phone": "(801) 630-2040"
          }
        ],
        "website": "https://www.abtaba.com/",
        "email": "info@abtaba.com",
        "cost": "Out-of-Network and single-case agreements.",
        "insurance": [
          {
            "name": "Blue Cross Blue Shield (BCBS)"
          },
          {
            "name": "Deseret Mutual Benefit Administrators (DMBA)"
          },
          {
            "name": "EMI Health"
          },
          {
            "name": "Medicaid"
          },
          {
            "name": "University of Utah Health Plans"
          }
        ],
        "counties_served": [
          {
            "county": "Utah, Salt Lake, Davis, Logan to Spanish Fork, Tooele"
          }
        ],
        "min_age": 2.0,
        "max_age": 21.0,
        "waitlist": "No",
        "telehealth_services": "Yes",
        "spanish_speakers": null,
        "at_home_services": null,
        "in_clinic_services": null
      }
    }
  ]
}
```
### Get Provider by ID

- **`GET /api/v1/providers/:id`**

Retrieves the details of a single provider based on the provided :id. Replace :id with the actual provider's ID (e.g., /api/v1/providers/1).
#### Response Example:

```json
  {
    "data": [
        {
            "id": 1,
            "type": "provider",
            "attributes": {
                "name": "A BridgeCare ABA",
                "locations": [
                    {
                        "name": "https://www.bridgecareaba.com/locations/aba-therapy-in-utah",
                        "address_1": null,
                        "address_2": null,
                        "city": null,
                        "state": null,
                        "zip": null,
                        "phone": "801-435-8088"
                    }
                ],
                "website": "https://www.bridgecareaba.com/locations/utah",
                "email": "info@bridgecareaba.com",
                "cost": "N/A",
                "insurance": [
                    {
                        "name": "Contact us"
                    }
                ],
                "counties_served": [
                    {
                        "county": "Salt Lake, Utah, Davis, Weber"
                    }
                ],
                "min_age": 2.0,
                "max_age": 16.0,
                "waitlist": "No",
                "telehealth_services": "Yes",
                "spanish_speakers": "Yes",
                "at_home_services": null,
                "in_clinic_services": null
            }
        }
      ]
    }
  ```
### UPDATE Provider by ID
- **`PATCH /api/v1/providers/1`**
**`PATCH /api/v1/providers/:id`**

Updates a provider's details, including their name, locations, services, and other information. Replace `:id` with the provider's ID you wish to update (e.g., `/api/v1/providers/1`).

#### Request Body Example:

```json
{
  "name": "A BridgeCare ABA",
  "locations": [
    {
      "name": "https://www.bridgecareaba.com/locations/aba-therapy-in-utah",
      "address_1": null,
      "address_2": null,
      "city": null,
      "state": null,
      "zip": null,
      "phone": "801-435-8088"
    }
  ],
  "website": "https://www.bridgecareaba.com/locations/utah",
  "email": "info@bridgecareaba.com",
  "cost": "N/A",
  "insurance": [
    {
      "name": "Contact us"
    }
  ],
  "counties_served": [
    {
      "county": "Salt Lake, Utah, Davis, Weber"
    }
  ],
  "min_age": 2.0,
  "max_age": 16.0,
  "waitlist": "No",
  "telehealth_services": "Yes",
  "spanish_speakers": "Yes",
  "at_home_services": null,
  "in_clinic_services": null
}
```
#### Response Example:

```json
  {
    "data": [
        {
            "id": 1,
            "type": "provider",
            "attributes": {
                "name": "A BridgeCare ABA",
                "locations": [
                    {
                        "name": "https://www.bridgecareaba.com/locations/aba-therapy-in-utah",
                        "address_1": null,
                        "address_2": null,
                        "city": null,
                        "state": null,
                        "zip": null,
                        "phone": "801-435-8088"
                    }
                ],
                "website": "https://www.bridgecareaba.com/locations/utah",
                "email": "info@bridgecareaba.com",
                "cost": "N/A",
                "insurance": [
                    {
                        "name": "Contact us"
                    }
                ],
                "counties_served": [
                    {
                        "county": "Salt Lake, Utah, Davis, Weber"
                    }
                ],
                "min_age": 2.0,
                "max_age": 16.0,
                "waitlist": "No",
                "telehealth_services": "Yes",
                "spanish_speakers": "Yes",
                "at_home_services": null,
                "in_clinic_services": null
            }
        }
      ]
    }
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
### Utah ABA Finder API is free and open to use. Because of this, we humbly ask developers to use it fairly. This is a service to aid parents, caregivers, and professionals.
