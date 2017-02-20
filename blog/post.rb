# post.rb
# Get all to be published .md files, and deploy to github.
# created by xbin999@gmail.com on Feb 16, 2017

require 'yaml'
require 'logger'

# get config from blog.yml
cfghash = YAML.load_file(File.join(__dir__, 'blog.yml'))
#puts cfghash

source = cfghash["source"]
destination = cfghash["destination"]
backup = cfghash["backup"]
prefix = cfghash["prefix"]
namesep = cfghash["namesep"] 
tagsep = cfghash["tagsep"]
logfile = cfghash["logfile"]

log = Logger.new(logfile)
log.info "Post begin."

count = 0
# loop to be published files
Dir["#{source}/#{prefix}*.md"].each do |ofile|
  # parse filename
  bname = File.basename(ofile, ".md").split(namesep)
  if bname.size >= 3 
    # bname[0] should be prefix
    tags = bname[1].split(tagsep)
    title = bname[2]
    date = File.mtime(ofile)

    # create new file
    nfile = "#{destination}/#{title}.md"
    open(nfile, 'w') { |f|
      # add hexo syntax, include title, date, tag
      f.puts "---"
      f.puts "title: #{title}"
      f.puts "date: #{date}"
      f.puts "tags: "
      tags.each {|tag|
        f.puts "  - #{tag}"
      }
      f.puts "---"
      # append original blog file
      f << File.read(ofile)
    }
    log.info "Create #{nfile}"

    # backup publish_ files 
    bfile = "#{backup}/backup#{namesep}#{bname[1]}#{namesep}#{title}.md"
    log.info "Backup [mv #{ofile} #{bfile}]"
    File.rename(ofile, bfile)
    count = count + 1
  else
    log.error "Error: The syntax of #{ofile} is error."
  end
end

if count > 0 
  # hexo generate and deploy
  log.info "Deploy #{count} posts begin."
  #rv = system("cd /Users/xbin999/db/hexo; /usr/local/bin/hexo g")
  `cd /Users/xbin999/db/hexo; hexo g -d`
  rv = $?.to_i
  if rv != 0 
    log.error "hexo generate and deploy error #{rv}."
  else
    log.info "Deploy #{count} posts end [hexo generate and deploy]"
  end
end

log.info "Post end."
