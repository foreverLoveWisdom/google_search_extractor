## Code Challenge Checklist

- The goal of this checklist is to provide a step-by-step guide for completing the given code challenge. This list should be followed to complete the application, including all necessary features and requirements.

### Overall Checklist:

- [x] Create a web application to extract large amounts of data from the Google search results page.
- [x] Find a way to work around the limitations of mass-searching keywords.
- [x] Store the extracted data and display it back to the users.
- [x] Users must be authenticated to use the application.
- [] Implement both a web interface and optional API.
- [x] Use PostgreSQL and write tests using a framework of your choice.
- [] Deploy the application to a cloud provider (optional).

### Web UI Checklist:

- [x] Implement sign in and sign up screens.
- [x] Implement a feature that allows authenticated users to upload a CSV file of keywords.
- [x] Implement a feature that allows users to view the list of their uploaded keywords.
- [x] Implement a feature that allows users to view the search result information stored in the database for each keyword.
- [x] Implement a search feature that allows users to search across all reports.

### API Checklist(Optional):

- [x] Implement an API sign in endpoint.
- [x] Implement an API endpoint to get the list of keywords.
- [x] Implement an API endpoint to upload a keyword file.
- [x] Implement an API endpoint to get the search result information for each keyword.

### Technical Requirements Checklist:

- [x] Choose a web framework of your choice.
- [x] Use PostgreSQL as the database.
- [x] Use front-end frameworks like Bootstrap, Tailwind, or Foundation to create the user interface.
- [x] Use SASS as the CSS preprocessor.
- [x] Write tests using a framework of your choice.
- [x] Use Git during the development process.
- [x] Push code to a public repository on Github or Gitlab.
- [x] Make regular commits and merge code using pull requests.

### Optional Checklist:

- [] Deploy the application to a cloud provider such as Heroku, AWS, Google Cloud, or Digital Ocean.

### Notes:

- The beginning commits are a bit messy 🙈💦🧹
- Since the CSV_upload feature, follow [ Git Flow ](https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow) , with Pull Request created to merge into the `develop` branch 🙏💡🌱
- 🙏 Regrettably, due to time constraints, I couldn't include the optional API endpoints, but I'm fully committed to completing them over the weekend while eagerly anticipating your feedback. 💪🤞🤗

### 💻 Requirements:

- Ruby 3.2.1
- PostgreSQL

### Database Connection Pooling

- In this project, we use the `:async` adapter for running background jobs, such as scraping keywords on Google and saving the results into the database. If you plan to run a large number of background jobs simultaneously, you may need to adjust the size of the database connection pool in the development environment.

- By default, Rails sets the connection pool size to 5 in the development environment. However, this may not be sufficient for running a large number of background jobs. As a starting point, we recommend setting the pool size to a value between 20 and 50, depending on the available resources on your development machine.

- To adjust the connection pool size, you can add the following line to your `config/database.yml` file:

```ruby
development:
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 20 } %>
```
- You can replace `20` with a different value that suits your needs. For more information on connection pooling, please refer to the [Rails configuration guide](https://guides.rubyonrails.org/configuring.html#database-pooling).

### 🛠️ Installation:

- Temporarily disable yarn build-related process in foreman and remove yarn build script due to a yarn script build bug. I will investigate further.🤔
- Clone this repository.
- Run `yard install` to install the dependencies.
- Run `bundle install` to install the required gems.
- Run `rails db:create` to create the database.
- Run `rails db:migrate` to run migrations.
- Run `rails db:seed` to seed the database with sample data.
- Run `rails server` or `foreman start -f Procfile.dev` to start the Rails server.
- Open your browser and go to http://localhost:3000/ to see the application running.

### 🔍 Running Tests:

- This application uses RSpec for testing. To run all tests, run the following command: `bundle exec rspec`
- Make sure you have installed all the development dependencies by running `bundle install --with development`

### 🤖 Guard:

- You can also use guard to run your tests automatically every time you make a change to your files. Run the following command to start guard:`bundle exec guard`

### 🤝 Contributing:

- Contributions, issues and feature requests are welcome!

### 📜 License:

- This project is licensed under the MIT License - see the LICENSE file for details.
