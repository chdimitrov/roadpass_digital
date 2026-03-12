class TripBlueprint < Blueprinter::Base
  identifier :id

  fields :name, :image_url, :short_description, :rating

  view :show do
    fields :long_description

    field :created_at do |trip|
      trip.created_at.iso8601
    end

    field :updated_at do |trip|
      trip.updated_at.iso8601
    end
  end
end
