require 'net/http'

h = Net::HTTP.new('wdj.anzhi.com', 80)
for i in 1..3693
  resp, data = h.get("/hotapp_#{i}.html", nil)
  puts "get htpapp_#{i}.html Code = #{resp.code}"
  #puts "Message = #{resp.code}"
  if resp.message == "OK"
    resp.each {|key, val| printf "%-14s = %-40.40s\n", key, val }
    o_file = File.open("anzhi/#{i}.html", "w")
    o_file.puts data
    o_file.close
  end
end

