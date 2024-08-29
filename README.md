# README
# Utah ABA Finder BE
<h2> This API manages the retrieval and delivery of Applied Behavior Analysis (ABA) provider information, while also handling authentication and permissions for the Utah ABA Finder frontend application. It is built to simplify the search for ABA services in Utah, helping parents, caregivers, and professionals to efficiently locate providers that best match their unique requirements and objectives.</h2>

## Table of Contents
- [Setup](#setup)
- [Endpoints](#endpoints)
- [Responses](#responses)
- [Contributors](#contributors)
- [Fair Use](#fair-use)

## Setup

These instructions will help you set up and run the project on your local machine for development and testing purposes.

### Prerequisites

Ensure you have the following software installed:

- Ruby 3.2.x
- Rails 7.x
- PostgreSQL

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

You can now access the API in your browser at http://localhost:3000.

## API Endpoints

You can use [Postman](https://www.postman.com/) to test endpoints.

## Endpoints

### Get All Providers
- **`GET /api/v1/providers`**
  - Returns a list of all ABA Providers and their information.

## Responses
- Base URL: https://uta-aba-finder-be-97eec9f967d0.herokuapp.com/
- All endpoints return data in JSON Format

### Ruby
- **`GET /api/v1/providers`**
  ```
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
        },
        ...
      ]
    }
  ```

## Contributors
- [Austin Carr Jones](https://github.com/austincarrjones)
- [Chee_Lee](https://github.com/cheeleertr)
- [Jordan Williamson](https://github.com/JWill06)
- [Kevin Nelson](https://github.com/kevinm23nelson)
- [Mel Langhoff](https://github.com/mel-langhoff)
- [Seong Kang](https://github.com/sanghoro)

## Fair Use
### Utah ABA Finder API is free and open to use. Because of this, we humbly ask developers to use it fairly. This is a service to aid parents, caregivers, and professionals.
