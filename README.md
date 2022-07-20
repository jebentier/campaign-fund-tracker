# Getting Started with CampaignFundTracker

This project is using a Sinatra API backend with a React frontend to help track the funds raised by political campaigns.

## Requirements

* node 16.x
* ruby 3.1
* sqlite3

## Getting started

To get your development environment set up, run `bin/setup` after cloning the repo. This will run a `yarn install` to
prepare the frontend environment, and a `bundle install` for the backend, as well as setting up the local database.

## Running the project

There is a `Procfile.dev` file in the project root, which tells Sinatra to run the backend server on port `3000` and the
frontend server on port `8080`.

```
foreman start -f Procfile.dev
```
