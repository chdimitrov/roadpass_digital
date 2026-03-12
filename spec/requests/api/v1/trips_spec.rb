require 'rails_helper'

RSpec.describe 'Api::V1::Trips', type: :request do
  let(:headers) { { 'Content-Type' => 'application/json', 'Accept' => 'application/json' } }

  describe 'GET /api/v1/trips' do
    context 'when trips exist' do
      before { create_list(:trip, 3) }

      it 'returns 200 with a list of trips' do
        get '/api/v1/trips', headers: headers

        expect(response).to have_http_status(:ok)
        expect(json_body.size).to eq(Trip.count)
      end

      it 'returns the expected fields' do
        get '/api/v1/trips', headers: headers

        trip = json_body.first
        expect(trip.keys).to match_array(%w[id name image_url short_description long_description rating created_at updated_at])
      end
    end

    context 'when no trips exist' do
      it 'returns 200 with an empty list' do
        get '/api/v1/trips', headers: headers

        expect(response).to have_http_status(:ok)
        expect(json_body).to eq([])
      end
    end

    context 'with search param' do
      before do
        create(:trip, name: 'Grand Canyon National Park')
        create(:trip, name: 'Yellowstone National Park')
        create(:trip, name: 'Zion Canyon National Park')
      end

      it 'returns only trips matching the search term (case-insensitive)' do
        get '/api/v1/trips', params: { search: 'canyon' }, headers: headers

        expect(response).to have_http_status(:ok)
        expect(json_body.size).to eq(2)
        expect(json_body.map { |t| t['name'] }).to contain_exactly(
          'Grand Canyon National Park',
          'Zion Canyon National Park'
        )
      end

      it 'returns all trips when search term matches all' do
        get '/api/v1/trips', params: { search: 'national park' }, headers: headers

        expect(response).to have_http_status(:ok)
        expect(json_body.size).to eq(3)
      end

      it 'returns an empty list when no trips match' do
        get '/api/v1/trips', params: { search: 'everglades' }, headers: headers

        expect(response).to have_http_status(:ok)
        expect(json_body).to eq([])
      end

      it 'ignores the search param when blank' do
        get '/api/v1/trips', params: { search: '' }, headers: headers

        expect(response).to have_http_status(:ok)
        expect(json_body.size).to eq(3)
      end
    end
  end

  describe 'GET /api/v1/trips/:id' do
    context 'when the trip exists' do
      let(:trip) { create(:trip) }

      it 'returns 200 with the trip' do
        get "/api/v1/trips/#{trip.id}", headers: headers

        expect(response).to have_http_status(:ok)
        expect(json_body['id']).to eq(trip.id)
        expect(json_body['name']).to eq(trip.name)
      end

      it 'returns the expected fields' do
        get "/api/v1/trips/#{trip.id}", headers: headers

        expect(json_body.keys).to match_array(%w[id name image_url short_description long_description rating created_at updated_at])
      end
    end

    context 'when the trip does not exist' do
      it 'returns 404 with an error message' do
        get '/api/v1/trips/99999', headers: headers

        expect(response).to have_http_status(:not_found)
        expect(json_body['error']).to be_present
      end
    end
  end

  describe 'POST /api/v1/trips' do
    context 'with valid params' do
      let(:valid_params) do
        {
          trip: {
            name: 'Yellowstone National Park',
            image_url: 'https://images.unsplash.com/photo-123456',
            short_description: 'A geothermal wonder with geysers and wildlife.',
            long_description: 'Yellowstone spans three states and sits atop a supervolcano, offering dramatic geothermal features, diverse wildlife, and some of the most spectacular scenery in North America.',
            rating: 5
          }
        }
      end

      it 'returns 201 with the created trip' do
        post '/api/v1/trips', params: valid_params.to_json, headers: headers

        expect(response).to have_http_status(:created)
        expect(json_body['name']).to eq('Yellowstone National Park')
        expect(json_body['rating']).to eq(5)
      end

      it 'persists the trip to the database' do
        expect {
          post '/api/v1/trips', params: valid_params.to_json, headers: headers
        }.to change(Trip, :count).by(1)
      end

      it 'returns the expected fields' do
        post '/api/v1/trips', params: valid_params.to_json, headers: headers

        expect(json_body.keys).to match_array(%w[id name image_url short_description long_description rating created_at updated_at])
      end
    end

    context 'with invalid params' do
      let(:invalid_params) { { trip: { name: '', rating: 10 } } }

      it 'returns 422 with error messages' do
        post '/api/v1/trips', params: invalid_params.to_json, headers: headers

        expect(response).to have_http_status(:unprocessable_content)
        expect(json_body['errors']).to be_an(Array)
        expect(json_body['errors']).not_to be_empty
      end

      it 'does not persist the trip' do
        expect {
          post '/api/v1/trips', params: invalid_params.to_json, headers: headers
        }.not_to change(Trip, :count)
      end
    end

    context 'with missing trip root key' do
      it 'returns 422 with an error message' do
        post '/api/v1/trips', params: {}.to_json, headers: headers

        expect(response).to have_http_status(:unprocessable_content)
        expect(json_body['error']).to be_present
      end
    end
  end

  private

  def json_body
    JSON.parse(response.body)
  end
end
