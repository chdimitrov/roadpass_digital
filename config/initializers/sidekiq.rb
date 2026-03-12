Sidekiq.configure_server do |config|
  config.redis = { url: ENV.fetch("REDIS_URL", "redis://localhost:6379/0") }

  Sidekiq::Cron::Job.load_from_hash(
    "trip_rating_summary" => {
      "class"  => "TripRatingSummaryJob",
      "cron"   => "0 0 * * *",
      "queue"  => "default",
      "active_job" => true
    }
  )
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV.fetch("REDIS_URL", "redis://localhost:6379/0") }
end

