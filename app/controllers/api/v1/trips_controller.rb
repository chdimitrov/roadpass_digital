module Api
  module V1
    class TripsController < ApplicationController
      before_action :set_trip, only: :show

      def index
        return unless stale?(
          etag: trips_index_fingerprint,
          last_modified: trips_index_fingerprint.first || Time.current,
          public: true
        )

        response.set_header("Cache-Control", "public, max-age=60, stale-while-revalidate=30")

        payload = Rails.cache.fetch(trips_index_cache_key, expires_in: 5.minutes) do
          pagy, trips = pagy(:offset, Trip.filter(params).result, limit: per_page)
          {
            data: TripBlueprint.render_as_hash(trips),
            meta: {
              page:        pagy.page,
              per_page:    pagy.limit,
              total:       pagy.count,
              total_pages: pagy.pages
            }
          }
        end

        render json: payload
      end

      def show
        return unless stale?(@trip, public: true)

        response.set_header("Cache-Control", "public, max-age=300")
        render json: TripBlueprint.render(@trip, view: :show)
      end

      def create
        trip = Trip.new(trip_params)

        if trip.save
          render json: TripBlueprint.render(trip, view: :show), status: :created
        else
          render json: { errors: trip.errors.full_messages }, status: :unprocessable_content
        end
      end

      private

      def set_trip
        @trip = Trip.find(params[:id])
      end

      def trip_params
        params.require(:trip).permit(:name, :image_url, :short_description, :long_description, :rating)
      end

      def trips_index_fingerprint
        @trips_index_fingerprint ||= [ Trip.maximum(:updated_at), Trip.count, index_query_params ]
      end

      def index_query_params
        @index_query_params ||= params.slice(:search, :min_rating, :sort, :page, :per_page).to_unsafe_h
      end

      def trips_index_cache_key
        max_updated_at, count, query = trips_index_fingerprint
        digest = Digest::MD5.hexdigest(query.to_s)
        "api/v1/trips/index/#{count}-#{max_updated_at&.to_i}-#{digest}"
      end
    end
  end
end
