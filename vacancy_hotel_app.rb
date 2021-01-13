require 'json'
require 'open-uri'
require 'active_support/core_ext'
require 'net/http'
require 'date'
require './hotel'
require './twitter'
require './hotel_url'


class VacaucyHotelApp
  REQUEST_URL = 'https://app.rakuten.co.jp/services/api/Travel/VacantHotelSearch/20170426'
  AFFILIATE_URL = "http://hb.afl.rakuten.co.jp/hgc/#{ENV['RAKUTEN_AFFILIATE_ID']}/"
  APP_ID = ENV['RAKUTEN_TRAVEL_VACANT_HOTEL_API_KEY']

  def initialize
    @previous_vacant_dates = []
  end

  def show_vacaucy_date
    while(1)
      @latest_vacant_dates = fetch_vacant_dates
      diff_vacant_dates.each do |date|
        # Tweet.new.update(date.display)
        p 'jmjojo'
      end
      @previous_vacant_dates = @latest_vacant_dates
    end
  end

  def diff_vacant_dates
    @previous_vacant_dates.select do |previous_vacant_date|
      (@latest_vacant_dates.find { |latest_vacant_date| latest_vacant_date.checkin_date == previous_vacant_date.checkin_date }).nil?
    end
  end

  def fetch_vacant_dates
    vacant_dates = []
    (Date.today..(Date.today + 30)).each do |checkin_date|
      hote_url = HotelUrl.new(REQUEST_URL, APP_ID, 151431, checkin_date)
      begin
        sleep(1)
        json = JSON.parse(hote_url.fetch_rakuten_api.read)
        hotel = json['hotels'][0]['hotel'][0]['hotelBasicInfo']
        vacant_dates.push(Hotel.new(hotel['hotelName'], checkin_date, to_affiliate_url((hotel['planListUrl']))))
      rescue => e
        puts e
      end
    end
    vacant_dates
  end

  def to_affiliate_url(hotel_url)
    "#{AFFILIATE_URL}?pc=#{hotel_url}&m=#{hotel_url}"
  end
end

VacaucyHotelApp.new.show_vacaucy_date