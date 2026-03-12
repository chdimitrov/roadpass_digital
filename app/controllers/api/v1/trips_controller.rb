module Api
  module V1
    class TripsController < ApplicationController
      before_action :set_trip, only: :show

      def index
        q = Trip.ransack(name_cont: params[:search])
        render json: TripBlueprint.render(q.result)
      end

      def show
        render json: TripBlueprint.render(@trip)
      end

      def create
        trip = Trip.new(trip_params)

        if trip.save
          render json: TripBlueprint.render(trip), status: :created
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
