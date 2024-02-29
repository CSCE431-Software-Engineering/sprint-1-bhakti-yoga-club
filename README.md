# README

## Introduction

We are working on creating an application for the Bhakti Yoga Club that will help potential and current club members be more active in the club. Our app hopes to help with the club's marketing and outreach by being a central hub by having a clean homepage and inform people about the club's activities and showcase upcoming events. Additionally, our application will allow administrators to keep track of all members, membership paid or unpaid dues, attendance, events, and anonymous member concerns. Lastly, club leaders will be able to post announcements that will be sent as emails to subscribers and plan events on our app calendar, which memebers will be able to view and check in for. 

## Requirements

This code has been run and tested on:

- Ruby - 3.0.2p107
- Rails - 6.1.4.1
- Ruby Gems - Listed in `Gemfile`
- PostgreSQL - 13.3
- Nodejs - v16.9.1
- Yarn - 1.22.11
- Docker (Latest Container)


## External Deps

- Docker - Download latest version at https://www.docker.com/products/docker-desktop
- Heroku CLI - Download latest version at https://devcenter.heroku.com/articles/heroku-cli
- Git - Downloat latest version at https://git-scm.com/book/en/v2/Getting-Started-Installing-Git
- GitHub Desktop (Not needed, but HELPFUL) at https://desktop.github.com/

## Installation

Download this code repository by using git:

`git clone https://github.com/CSCE431-Software-Engineering/sprint-1-bhakti-yoga-club.git`
 or 
 `git clone https://github.com/CSCE431-Software-Engineering/sprint-1-bhakti-yoga-club/`

## Tests

An RSpec test suite is available and can be ran using:

`rspec spec/`

You can run all the test cases by running. This will run both the unit and integration tests.
`rspec .`

## Execute Code

Run the following code in Powershell if using windows or the terminal using Linux/Mac

`cd sprint-1-bhakti-yoga-club`

`docker run --rm -it --volume "$(pwd):/rails_app" -e DATABASE_USER=test_app -e DATABASE_PASSWORD=test_password -p 3000:3000 dmartinez05/ruby_rails_postgresql:latest`


Install the app

`bundle install && rails webpacker:install && rails db:create && db:migrate`


Run the app
`rails server --binding:0.0.0.0`


The application can be seen using a browser and navigating to http://localhost:3000/


## Environmental Variables/Files

Google OAuth2 support requires two keys to function as intended: Client ID and Client Secret

Go to config/environments/ folder and in the development.rb, production.rb, and test.rb files set up google cloud:

  `GOOGLE_OAUTH_CLIENT_ID: 'YOUR_GOOGLE_OAUTH_CLIENT_ID_HERE'`

  `GOOGLE_OAUTH_CLIENT_SECRET: 'YOUR_GOOGLE_OAUTH_CLIENT_SECRET_HERE'`



## Deployment

Setup a Heroku account: https://signup.heroku.com/

From the heroku dashboard select `New` -> `Create New Pipline`

Name the pipeline, and link the respective git repo to the pipline

Our application does not need any extra options, so select `Enable Review Apps` right away

Click `New app` under review apps, and link your test branch from your repo

Under staging app, select `Create new app` and link your main branch from your repo

## CI/CD ##

CI/CD has been implemented in the GitHub Actions in the repo here -> (https://github.com/CSCE431-Software-Engineering/sprint-1-bhakti-yoga-club/actions)

For continuous development, we set up Heroku to automatically deploy our apps when their respective github branches are updated.

  `Review app: test branch`

  `Production app: main branch`

For continuous integration, we set up a Github action to run our specs, security checks, linter, etc. after every push or pull-request. This allows us to automatically ensure that our code is working as intended.


## Support

Admins looking for support should first look at the application help page or contact development team. 
Users looking for help seek out club leaders. 
