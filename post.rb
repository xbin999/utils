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
require 'optparse'

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

options = {}
optparse = OptionParser.new do|opts|
   # Set a banner, displayed at the top
   # of the help screen.
   opts.banner = "Usage: post.rb [options] file"
   opts.separator ""
   opts.separator "Specific options:"
 
   # Define the options, and what they do
   opts.on( '-s', '--title [BlogTitle]', 'Blog title' ) do|title|
     options[:title] = title
   end
 
   options[:tags] = nil
   opts.on( '-t', '--tags tag1,tag2,tag3', Array, 'Tags blog' ) do|tags|
     options[:tags] = tags
   end

   options[:categories] = nil
   opts.on( '-c', '--categories cat1,cat2,cat3', Array, 'Blog categories' ) do|categories|
     options[:categories] = categories
   end
 
   opts.on( '-h', '--help', 'Display this message' ) do
     puts opts
     exit
   end
end

begin
  optparse.parse!
  mandatory = [:tags, :categories] 
  missing = mandatory.select{ |param| options[param].nil? } 
  if not missing.empty?
    puts "Missing options: #{missing.join(', ')}" 
    puts optparse 
    exit
  end     
rescue OptionParser::InvalidOption, OptionParser::MissingArgument
  puts $!.to_s 
  puts optparse
  exit
end

title = options[:title]
tags = options[:tags]
categories = options[:categories]

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
