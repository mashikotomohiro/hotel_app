require 'json'
require 'open-uri'
require 'active_support/core_ext'
require 'net/http'

class HotelUrl
  def initialize(request_url, app_id, hotel_number, checkin_date)
    @request_url = request_url
    @app_id = app_id
    @hotel_number = hotel_number
    @checkin_date = checkin_date
  end

  def fetch_rakuten_api
    latest_vacant_dates = []
    uri = URI(@request_url)
    uri_query = {}
    uri_query[:format] = 'json'
    uri_query[:applicationId] = @app_id
    uri_query[:hotelNo] = @hotel_number
    uri_query[:checkinDate] = @checkin_date
    uri_query[:checkoutDate] = @checkin_date + 1
    uri.query = uri_query.to_param
    URI.open(uri)
  end
end