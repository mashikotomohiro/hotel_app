class Hotel
  attr_accessor :checkin_date
  def initialize(hote_name, checkin_date, hotel_url)
    @hotel_name = hote_name
    @checkin_date = checkin_date
    @time = Time.new
    @hotel_url = hotel_url
  end

  def display
    "キャンセル情報 #{@hotel_name} 
#{checkin_date_to_string} #{@hotel_url} (#{now}現在)"
  end

  def now
    " #{@time.monthj}月#{@time.day}日#{@time.hour}時#{@time.min}分"
  end

  def checkin_date_to_string
    @checkin_date.strftime("%m月%d日")
  end
end