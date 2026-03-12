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

## Further to improve
- No authentication — anyone on the internet can call POST /api/v1/trips and create trips.
- Sidekiq dashboard is wide open — /sidekiq is mounted with no password. In production, anybody could see and control your background jobs. It needs at minimum HTTP Basic Auth.
- No rate limiting — nothing stops someone from hammering the API with thousands of requests per second.
- Can't update or delete a trip — the API only has index, show, and create. There are no PUT /trips/:id or DELETE /trips/:id endpoints.
- Search is name-only — the search param only looks inside the trip name. It could also search the short or long description.
- 