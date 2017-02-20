#!/bin/bash

#date >> /tmp/MyLaunchdTest.out
#echo $PATH >> /tmp/hexo.log
PATH=/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/opt/X11/bin
source /Users/xbin999/.bash_profile 
#echo $PATH >> /tmp/hexo.log
ruby /Users/xbin999/bin/shell/blog/post.rb
#cd /Users/xbin999/db/hexo; /usr/local/bin/hexo -d 
#echo $? >> /tmp/hexo.log
