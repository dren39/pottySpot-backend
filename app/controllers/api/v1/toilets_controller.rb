class Api::V1::ToiletsController < ApplicationController

  def index
    @toilets = Toilet.all
    render json: @toilets
  end

  def api_request
    lat = params[:lat]
    lng = params[:lng]
    url = "https://www.refugerestrooms.org/api/v1/restrooms/by_location?page=1&per_page=10&offset=0&lat=#{lat}&lng=#{lng}"
    response = RestClient.get(url)
    hash = JSON.parse(response)
  end

  def create
    @toilets = []
    api_request.each do |toilet|
      new_toilet = Toilet.find_or_create_by(api_id: toilet["id"], name: toilet["name"], street: toilet["street"], city: toilet["city"], state: toilet["state"], directions: toilet["directions"], comments: toilet["comment"], lat: toilet["latitude"], long: toilet["longitude"], distance: toilet["distance"])
      @toilets << new_toilet
    end
    render json: @toilets
  end
end
