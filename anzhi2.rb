# encoding:utf-8

for i in 1..3693
  data = File.read("anzhi/#{i}.html")
  regex = /(版本：)(?<version>[\d|.]{1,20})([\u0000-\uffff]*?)(下载：)(?<downloads>\d{1,10})(次[\u0000-\uffff]*?\<div class=\"bot\"\>)(?<description>[\u0000-\uffff]{1,100}?)(\<\/div\>[\u0000-\uffff]*?javascript:on_install\(\')(?<product>[\u0000-\uffff]{1,100}?)\'/
#  regex = /javascript:on_install\(\'([\u0000-\uffff]{1,100}?)\'/
  data.scan(regex).each{ |m| puts "#{m[1]};#{m[3]};#{m[0]}"}
end
