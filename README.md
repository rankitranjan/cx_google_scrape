# Search Engine Results Page(SERP)

## Description
A Ruby on Rails application using PostgreSQL as the database, SCSS as the CSS preprocessor, Bootstrap for the front-end framework, and Devise for user authentication.

## Features
- User authentication with Devise
- Responsive UI with Bootstrap
- SCSS for styling
- PostgreSQL as the database

## Prerequisites
Ensure you have the following installed:
- Ruby (version specified in `.ruby-version`)
- Rails (version specified in `Gemfile`)
- PostgreSQL
- Node.js & Yarn (for managing assets)

## Installation

1. Clone the repository:
   ```sh
   git clone https://github.com/yourusername/projectname.git
   cd projectname
   ```

2. Install dependencies:
   ```sh
   bundle install
   yarn install
   ```

3. Set up the database:
   ```sh
   rails db:create db:migrate db:seed
   ```

4. Start the Rails server:
   ```sh
   rails server
   ```

5. Open your browser and navigate to:
   ```
   http://localhost:3000
   ```

## Configuration
### Environment Variables
Set up the following environment variables in your `.env` file:
```
DATABASE_USERNAME=your_username
DATABASE_PASSWORD=your_password
DATABASE_NAME=your_password
```

## Usage
- Sign up and log in using Devise
- Manage users and authentication
- Utilize Bootstrap UI components
- Extend styles with SCSS

## Testing
Run the test suite:
```sh
rails test
```

## Deployment
To deploy the application, ensure you have:
1. Configured `database.yml` for production.
2. Precompiled assets:
   ```sh
   rails assets:precompile
   ```
3. Set up the production database:
   ```sh
   rails db:migrate RAILS_ENV=production
   ```

## Contributing
1. Fork the repository
2. Create a new branch (`git checkout -b feature-branch`)
3. Commit your changes (`git commit -m 'Add new feature'`)
4. Push to the branch (`git push origin feature-branch`)
5. Open a Pull Request
