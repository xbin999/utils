#!/Users/yangbin/.rvm/rubies/ruby-1.9.3-p125/bin/ruby
# Convert a Markdown README to HTML with Github Flavored Markdown(refer to https://gist.github.com/ttscoff/3732963), and publish it to wordpress.
#
# Requirements: json gem (`gem install json`)
#
# Input: filename
# Output: STDOUT 
# Arguments: "-s" to speify title, -t to specify tags, -c to specify categories
# ruby post.rb [-s "title"] -t "tag1,tag2" -c "category1,category2" filename 

require 'rubygems'
require 'json'
require 'net/https'
require 'xmlrpc/client'

def publish_to_wordpress(title, content, tags, categories)
  # build a post
  post = {
    'title'       => title,
    'description' => content,
    'mt_keywords' => tags,
    'categories'  => categories
  }

  # initialize the connection
  connection = XMLRPC::Client.new('xbin999.com', '/xmlrpc.php')

  # make the call to publish a new post
  connection.call(
    'metaWeblog.newPost',
    1,
    'xbin999@gmail.com',
    'TZwxOEE*$0)(',
    post,
    true
  )
end

def get_param(pattern)
  if ARGV[0] == pattern
  	ARGV.shift
  	value = ARGV[0]
  	ARGV.shift
  	return value
  end
end

title = get_param("-s")
tags = get_param("-t").split(",") 
categories = get_param("-c").split(",") 

input = ''
if ARGV.length > 0
    filename = File.expand_path(ARGV[0])
    title = File.basename(filename,File.extname(filename))
	if File.exists?(filename)
		input = File.new(filename).read
	else
		puts "File not found: #{ARGV[0]}"
	end
else
	if STDIN.stat.size > 0
		input = STDIN.read
	else
		puts "No input specified"
	end
end

exit if input == ''

output = {}
output['text'] = input
output['mode'] = 'gfm'

url = URI.parse("https://api.github.com/markdown")
request = Net::HTTP::Post.new("#{url.path}")
request.body = output.to_json
http = Net::HTTP.new(url.host, url.port)
http.use_ssl = true
response = http.start {|http| http.request(request) }

if response.code == "200"
	html=<<ENDOUTPUT
<!DOCTYPE HTML>
<html lang="en-US">
<head>
	<meta charset="UTF-8">
	<title></title>
</head>
<body>
<div id="wrapper">
#{response.body}
</div>
</body>
</html>
ENDOUTPUT
  puts html
  html = html.force_encoding("UTF-8").encode("UTF-8")
	publish_to_wordpress(title, html, tags, categories) 
else
	puts "Error #{response.code}"
end


