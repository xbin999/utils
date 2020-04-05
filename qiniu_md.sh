#!/bin/zsh
# upload image to qiniu cloud, and copy image markdown syntax to clipboard
# depend on [qshell](https://developer.qiniu.com/kodo/tools/1302/qshell), qrsync is depreated.


/Users/xbin999/bin/qshell qupload /Users/xbin999/bin/qiniu-conf.json 2>&1 |sed -e 's/\(=> \)\(.*\)/=> ![](http:\/\/xbinimg.smsexplorer.cn\/\2\)/' >/Users/xbin999/tmp/.qiniu.log

rm /Users/xbin999/db/qiniu/images/*

cat /Users/xbin999/tmp/.qiniu.log |grep "\!\[\]" | awk -F '=>' '{print $2}' | awk -F ' ' '{print $1 " ]"}' | pbcopy

cat /Users/xbin999/tmp/.qiniu.log
