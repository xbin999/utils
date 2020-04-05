# encoding: utf-8

require 'nokogiri'
require 'open-uri'

module ParseUtil
  class ParseDangdangUtil

    def self.parse_search(source)
      doc = Nokogiri::HTML(open("#{URI.encode(source)}"),nil,"gbk")
      links = doc.css("li.line1 a")
      #puts links 
      if links[0].nil?
        link = ""
      else
        link = links[0]['href']
      end
      return link
    end
  end

end

filename = "booklist.txt"
books = []
File.open(filename, "r") do |f|
  f.each_line do |line|
    bookName = line.strip
    url = "http://search.dangdang.com/?key=#{bookName}&ddsale=1&category_path=01.00.00.00.00.00#J_tab"
    puts url 
    link = ParseUtil::ParseDangdangUtil.parse_search(url)
    sku = link[/\d+/]
    puts  "#{bookName};#{sku};#{link}"
    books.push("#{bookName};#{sku};#{link}")
  end
end

File.open("booklist.csv", "w") do |f|
  books.each { |element| f.puts(element) }
end