require 'faraday'
require 'nokogiri'

# {
#   day: :weekday :weekend :holiday
#   hour: 1
#   sa: true
#   twin: true
# }

# Sho 23 and 24, to SFC
web = Faraday.get 'http://www.kanachu.co.jp/dia/diagram/timetable/cs:0000800209-1/nid:00129893'
doc = Nokogiri::HTML(web.body)

(0..2).each do |type|
  (5..23).each do |hour|
    ruby = doc.css("#hour_#{type}_#{hour} .ruby").children
    doc.css("#hour_#{type}_#{hour} a").children.each_with_index do |a, i|
      puts "Type: #{type}, #{hour}:#{a.inner_text}, Ruby: #{ruby[i].inner_text}"
    end
  end
end

# Sho 25, to SFC
web = Faraday.get 'http://www.kanachu.co.jp/dia/diagram/timetable/cs:0000802872-1/nid:00129893/dts:1570080300'
doc = Nokogiri::HTML(web.body)

(0..2).each do |type|
  (5..23).each do |hour|
    doc.css("#hour_#{type}_#{hour} a").children.each_with_index do |a, i|
      puts "Type: #{type}, #{hour}:#{a.inner_text}, Twin"
    end
  end
end

