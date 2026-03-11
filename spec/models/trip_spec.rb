require 'rails_helper'

RSpec.describe Trip, type: :model do
  subject { build(:trip) }

  describe 'validations' do
    describe 'name' do
      it { is_expected.to validate_presence_of(:name) }
      it { is_expected.to validate_length_of(:name).is_at_most(255) }
      it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
    end

    describe 'image_url' do
      it { is_expected.to validate_presence_of(:image_url) }
      it { is_expected.to validate_length_of(:image_url).is_at_most(2048) }

      it 'rejects URLs without http/https protocol' do
        expect(build(:trip, image_url: 'example.com/image.jpg')).not_to be_valid
      end

      it 'rejects invalid protocols' do
        expect(build(:trip, image_url: 'ftp://example.com/image.jpg')).not_to be_valid
      end
    end

    describe 'short_description' do
      it { is_expected.to validate_presence_of(:short_description) }
      it { is_expected.to validate_length_of(:short_description).is_at_least(10).is_at_most(500) }
    end

    describe 'long_description' do
      it { is_expected.to validate_presence_of(:long_description) }
      it { is_expected.to validate_length_of(:long_description).is_at_least(20).is_at_most(5000) }
    end

    describe 'rating' do
      it { is_expected.to validate_presence_of(:rating) }
      it { is_expected.to validate_numericality_of(:rating).only_integer.is_greater_than_or_equal_to(1).is_less_than_or_equal_to(5) }
    end
  end
end
