module Api
  module V1
    class TripsController < ApplicationController
      before_action :set_trip, only: :show

      def index
        pagy, trips = pagy(:offset, Trip.filter(params).result, limit: per_page)

        render json: {
          data: TripBlueprint.render_as_hash(trips),
          meta: {
            page:        pagy.page,
            per_page:    pagy.limit,
            total:       pagy.count,
            total_pages: pagy.pages
          }
        }
      end

      def show
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
    end
  end
end
