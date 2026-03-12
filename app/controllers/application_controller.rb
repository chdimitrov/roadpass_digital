class ApplicationController < ActionController::API
  include Pagy::Method

  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActionController::ParameterMissing, with: :bad_request

  private

  def not_found(exception)
    render json: { error: exception.message }, status: :not_found
  end

  def bad_request(exception)
    render json: { error: exception.message }, status: :unprocessable_content
  end

  def per_page
    params[:per_page].to_i.positive? ? params[:per_page].to_i : Pagy::OPTIONS[:limit]
  end
end
