# CX Google Scraper

Live on Heroku: [CX Google Scraper](https://google-scraper-251b97ca7195.herokuapp.com)

Sidekiq:[Sidekiq](https://google-scraper-251b97ca7195.herokuapp.com/sidekiq)  

## Overview
CX Google Scraper is a Ruby on Rails application designed to scrape Google search results, manage keyword searches, and store relevant data such as AdWords count, total links, and cached HTML. It supports authentication, and random delays to avoid detection.

## Features
- **CSV Upload**: Upload keyword lists via CSV (note: the file is not stored, only its content is read).
- **Google Search Scraping**: Extracts total search results, ads count, and links.
- **Proxy Support**: Rotates proxies to prevent blocking.
- **Authentication**: Secures access to keyword searches.
- **Deployment Ready**: Configured for deployment on Heroku with a `Procfile`.

## Installation
### Prerequisites
Ensure you have the following installed:
- Ruby (version specified in `.ruby-version`)
- Bundler
- PostgreSQL
- Redis
- Node.js

### Setup Instructions
1. Clone the repository:
   ```sh
   git clone <repository-url>
   cd cx_google_scraper
   ```
2. Install dependencies:
   ```sh
   bundle install
   npm install
   ```
3. Set up the database:
   ```sh
   rails db:create db:migrate
   ```
4. Start the server:
   ```sh
   rails s
   ```
5. Run background jobs (if applicable):
   ```sh
   bundle exec sidekiq
   ```

## API Endpoints

### 1. User Login
**Endpoint:** `POST /api/v1/auth/sign_in`
**Description:** Retrieves the stored keywords.
**Request:**
```sh
curl --location 'http://localhost:3000/api/v1/auth/sign_in' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'email=<youe_email>' \
--data-urlencode 'password=<you_passwprd>'
```

**Response :**
```json
{
    "token": "<your toekn string>"
}
```

### 2. Upload Keywords
**Endpoint:** `POST /api/v1/keywords/upload`
**Description:** Accepts a CSV file, reads its content, and processes the keywords.
**Request:**
```sh
curl --location 'http://localhost:3000/api/v1/keywords/upload' \
--header 'Authorization: Bearer <your_token>' \
--form 'file=@"/Users/rankitranjan/Downloads/Untitled spreadsheet - sample_keywords (7).csv"'
```
**Response:**
```json
{
    "message": "File uploaded successfully"
}
```

### 3. Fetch Search Results
**Endpoint:** `GET /api/v1/search?q=buy&page=1`
**Description:** Retrieves the keywords search results.
**Request:**
```sh
curl --location 'http://localhost:3000/api/v1/search?q=buy&per_page=20&page=1' \
--header 'Authorization: Bearer <your_token>'
```
**Response :**
```json
{
   "keywords": [
        {
            "id": 73,
            "name": "white dress buy",
            "total_ads": 9,
            "total_links": 371,
            "total_results": "3120000000",
            "status": "completed",
            "created_at": "2025-02-23T18:55:04.941Z"
        }
     ],
   "meta": {
        "current_page": 1,
        "total_pages": 4,
        "total_count": 68
    }    
}
```

### 4. Fetch Keyword list
**Endpoint:** `GET /api/v1/keywords?q=buy&page=1`
**Description:** Retrieves the stored keywords.
**Request:**
```sh
curl --location 'http://localhost:3000/api/v1/keywords?per_page=20&page=1' \
--header 'Authorization: Bearer <your_token>'
```

**Response :**
```json
{
   "keywords": [
        {
            "id": 73,
            "name": "white dress buy",
            "total_ads": 9,
            "total_links": 371,
            "total_results": "3120000000",
            "status": "completed",
            "created_at": "2025-02-23T18:55:04.941Z"
        },
        {
         "........"
        }
     ],
   "meta": {
        "current_page": 1,
        "total_pages": 4,
        "total_count": 68
    }      
}
```


## Business Logic: SearchService
The scraping logic is implemented in the `SearchService`. It follows these steps:
1. Read the keywords from the uploaded CSV (without storing the file).
2. Construct Google search queries dynamically.
3. Use a headless browser chromium to perform searches and scraping.
4. Extract key data like total search results, AdWords count, and links.
5. Store the processed data in the database.
6. Rotate proxies and introduce random delays to mimic human behavior.

## Running Tests
To run the test suite using RSpec:
```sh
rspec
```
### Sample Test Coverage Result
```sh
Coverage report generated for RSpec to /coverage
90.5% total coverage
100% models coverage
85% services coverage
```

## Environment Variables
- `RAILS_ENV` (development/production)
- `DATABASE_URL` (for PostgreSQL connection)
- `REDIS_URL` (for redis connection)


## Deployment
For Heroku:
```sh
heroku create
heroku buildpacks:add heroku/nodejs
heroku buildpacks:add heroku/ruby
heroku addons:create heroku-postgresql:hobby-dev
heroku config:set RAILS_MASTER_KEY=<your-master-key>
git push heroku main
```
