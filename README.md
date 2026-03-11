# README

# Local development

## build and start containers
```bash
docker compose up --build
```

## Seed database
```bash
bundle exec rails db:seed
```

## running tests
> Note: Dockerized environment, 
> if you want to execute commands from outside the container, you should
> prefix command with ```docker compose exec app``` 

```bash
bundle exec rspec
```

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
