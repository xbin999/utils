# computus.rb

Y = ARGV[0].to_i
if Y == 0 then Y = Time.now.year() end
if Y>=1583 and Y<1700 then 
    M = 22
    N = 2
end
if Y>=1700 and Y<1800 then 
    M = 23 
    N = 3 
end
if Y>=1800 and Y<1900 then 
    M = 23 
    N = 4 
end
if Y>=1900 and Y<2100 then 
    M = 24 
    N = 5 
end
if Y>=2100 and Y<2200 then 
    M = 24 
    N = 6 
end
if Y>=2200 and Y<2300 then 
    M = 25 
    N = 0 
end

a = Y % 19
b = Y % 4
c = Y % 7
d = (19*a + M) % 30
e = (2*b + 4*c + 6*d + N) % 7

if ( d+e < 10) then
    month = 3
    day = d + e + 22
else
    month = 4
    day = d + e -9
end

if (month==4 and (day==26 or (day==25 and d==28 and e==6 and a>10))) then
    day = day - 7
end

puts "#{month}/#{day}"

