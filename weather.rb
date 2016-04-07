#    Des: 此脚本用于获取不同城市的天气
# Author: Fred
#   Date: 2016.04.07 17:30

require 'active_support/core_ext/hash'
require "net/http"

#不同城市天气数据地址
shanghai = URI('http://wthrcdn.etouch.cn/WeatherApi?city=%E4%B8%8A%E6%B5%B7')
qingdao = URI('http://wthrcdn.etouch.cn/WeatherApi?city=%E9%9D%92%E5%B2%9B')
shenzhen = URI('http://wthrcdn.etouch.cn/WeatherApi?city=%E6%B7%B1%E5%9C%B3')
uri = shanghai

#外部参数解析
arg0 = ARGV[0]
if !arg0.nil? then
	if arg0 == "qd" then		#青岛
		uri = qingdao
	elsif arg0 == "sz" then		#深圳
		uri = shenzhen
	end
end


#系统时间
today = Time.new
timeStr = today.strftime("%Y-%m-%d %H:%M:%S");

#请求天气数据
res = Net::HTTP.get_response(uri).body
data = Hash.from_xml(res)

#城市基本信息
city = data['resp']['city'];
updatetime = data['resp']['updatetime']

puts "\n#{city}  #{timeStr}    天气更新时间:#{updatetime}"
puts ""

#解析天气警告
alarm = data['resp']['alarm']
if !alarm.nil? then
	alarmText = alarm['alarmText']
	alarm_details = alarm['alarm_details']
	#puts "Alarm: #{alarmText}"
	puts "Alarm:\033[33m #{alarmText}\033[0m\n"
	puts "\n#{alarm_details}\n\n"
end

#解析未来5天天气情况
forecast = data['resp']['forecast']
(0..4).each do |n|
	weather = forecast['weather'][n]

	date = weather['date']
	high = weather['high']
	low = weather['low']
	day = weather['day']
	day_type = day['type']
	day_fengxiang = day['fengxiang']
	day_fengli = day['fengli']

	night = weather['night']
	night_type = night['type']
	night_fengxiang = night['fengxiang']
	night_fengli = night['fengli']

	puts "#{date}\t#{high}  #{low}\t#{day_type.rjust(2,' ')} ~ #{night_type.ljust(2,' ')}\t#{day_fengli}  #{night_fengli}"
	puts "----------------------------------------------------------------------"
end


=begin
puts "\033[1mForeground Colors...\033[0m\n"  
puts "   \033[30mBlack (30)\033[0m\n"  
puts "   \033[31mRed (31)\033[0m\n"  
puts "   \033[32mGreen (32)\033[0m\n"  
puts "   \033[33mYellow (33)\033[0m\n"  
puts "   \033[34mBlue (34)\033[0m\n"  
puts "   \033[35mMagenta (35)\033[0m\n"  
puts "   \033[36mCyan (36)\033[0m\n"  
puts "   \033[37mWhite (37)\033[0m\n"  
puts ''  
  
puts "\033[1mBackground Colors...\033[0m\n"  
puts "   \033[40m\033[37mBlack (40), White Text\033[0m\n"  
puts "   \033[41mRed (41)\033[0m\n"  
puts "   \033[42mGreen (42)\033[0m\n"  
puts "   \033[43mYellow (43)\033[0m\n"  
puts "   \033[44mBlue (44)\033[0m\n"  
puts "   \033[45mMagenta (45)\033[0m\n"  
puts "   \033[46mCyan (46)\033[0m\n"  
puts "   \033[47mWhite (47)\033[0m\n"  
puts ''  
puts "\033[1mModifiers...\033[0m\n"  
puts "   Reset (0)"  
puts "   \033[1mBold (1)\033[0m\n"  
puts "   \033[4mUnderlined (4)\033[0m\n"  
=end
sleep 30