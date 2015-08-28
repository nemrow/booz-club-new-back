class SearchController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :add_headers

  def new
    render json: {success: true}
  end

  private

  def add_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
    headers['Access-Control-Request-Method'] = '*'
    headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
  end
end
