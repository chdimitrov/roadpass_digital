class TripBlueprint < Blueprinter::Base
  identifier :id

  fields :name, :image_url, :short_description, :long_description, :rating

  field :created_at do |trip|
    trip.created_at.iso8601
  end

  field :updated_at do |trip|
    trip.updated_at.iso8601
  end
end
