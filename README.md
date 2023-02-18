## Code Challenge Checklist

- The goal of this checklist is to provide a step-by-step guide for completing the given code challenge. This list should be followed to complete the application, including all necessary features and requirements.

### Overall Checklist:

- [] Create a web application to extract large amounts of data from the Google search results page.
- [] Find a way to work around the limitations of mass-searching keywords.
- [] Store the extracted data and display it back to the users.
- [] Users must be authenticated to use the application.
- [] Implement both a web interface and optional API.
- [] Use PostgreSQL and write tests using a framework of your choice.
- [] Deploy the application to a cloud provider (optional).
- [] Web UI Checklist
- [] Implement sign in and sign up screens.
- [] Implement a feature that allows authenticated users to upload a CSV file of keywords.
- [] Implement a feature that allows users to view the list of their uploaded keywords.
- [] Implement a feature that allows users to view the search result information stored in the database for each keyword.
- [] Implement a search feature that allows users to search across all reports.

### API Checklist(Optional):

- [] Implement an API sign in endpoint.
- [] Implement an API endpoint to get the list of keywords.
- [] Implement an API endpoint to upload a keyword file.
- [] Implement an API endpoint to get the search result information for each keyword.

### Technical Requirements Checklist:

- [] Choose a web framework of your choice.
- [x] Use PostgreSQL as the database.
- [] Use front-end frameworks like Bootstrap, Tailwind, or Foundation to create the user interface.
- [] Use SASS as the CSS preprocessor.
- [x] Write tests using a framework of your choice.
- [x] Use Git during the development process.
- [x] Push code to a public repository on Github or Gitlab.
- [x] Make regular commits and merge code using pull requests.

### Optional Checklist:

- [] Deploy the application to a cloud provider such as Heroku, AWS, Google Cloud, or Digital Ocean.

### Notes:

- The beginning commits are a bit messy 🤦 🤷
- Since the CSV_upload feature, follow [ Git Flow ](https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow) , with Pull Request created to merge into the `develop` branch
