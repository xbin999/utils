# encoding: utf-8

require 'nokogiri'
require 'open-uri'

module ParseUtil
  class ParseJDUtil

    def self.search(product)
    end

    def self.parse_product(source)
      target = Hash.new
      name = ""
      doc = Nokogiri::HTML(open(source))
      # Get product name
      doc.css("div.sku-name").each do |infos|
        puts "#{infos.text}"
        target["sku-name"] = infos.text
      end

      # Get  info
      price_wrap = doc.css('div.summary-price')
      puts price_wrap.text
      return

      doc.css("div.summary-price-wrap").each do |infos|
        infos.text.split("\n").each do |info|
          if !info.strip.empty?
            if name == "作者"
              #puts "Waited #{info}"
              value = info
              #puts "#{name} => #{value}"
              target[name.strip] = value.strip
              name = ""
            else
              name, value = info.strip.split(":")
              if name == "作者"
                #puts "Wait next value"
                next
              end
              #puts "#{name} => #{value}"
              if value != nil
                target[name.strip] = value.strip
              end
            end
          end
        end
      end

      puts target
      return target

    end
  end

end

ParseUtil::ParseJDUtil.parse_product("https://item.jd.com/1785863157.html")
