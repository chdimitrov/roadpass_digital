# README

# Local development

## build and start containers
this will start up application and seed database
```bash
docker compose up --build
```

## Seed database manually
```bash
bundle exec rails db:seed
```

## running tests
> Note: Dockerized environment, 
> if you want to execute commands from outside the container, you should
> prefix command with ```docker compose exec app``` 

```bash
docker compose exec -e RAILS_ENV=test app bundle exec rspec
RAILS_ENV=test bundle exec rspec
```
## Trigger job manually
```bash
docker compose exec app bundle exec rails runner "TripRatingSummaryJob.perform_later"
```

## Useful commands
- Linting: ```bundle exec rubocop```
- Security audit: ```bundle exec brakeman```
- Gem vulnerability check: ```bundle exec bundler-audit```
- Console: ```bundle exec rails console```

## Troubleshooting
- reset everything: ```docker compose down -v```