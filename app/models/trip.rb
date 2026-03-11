class Trip < ApplicationRecord
  validates :name,
            presence: true,
            length: { minimum: 1, maximum: 255 },
            uniqueness: { case_sensitive: false }

  validates :image_url,
            presence: true,
            length: { maximum: 2048 },
            format: {
              with: URI::DEFAULT_PARSER.make_regexp(%w[http https])
            }

  validates :short_description,
            presence: true,
            length: { minimum: 10, maximum: 500 }

  validates :long_description,
            presence: true,
            length: { minimum: 20, maximum: 5000 }

  validates :rating,
            presence: true,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 1,
              less_than_or_equal_to: 5
            }
end
