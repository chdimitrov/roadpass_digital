class Trip < ApplicationRecord
  validates :name,              presence: true, uniqueness: { case_sensitive: false }
  validates :image_url,         presence: true
  validates :short_description, presence: true
  validates :long_description,  presence: true
  validates :rating,            presence: true,
                                numericality: {
                                  only_integer: true,
                                  greater_than_or_equal_to: 1,
                                  less_than_or_equal_to: 5
                                }
end
