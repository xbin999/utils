#!/bin/zsh
# upload image to qiniu cloud, and copy image markdown syntax to clipboard
# depend on [qrsync](http://qiniu-developer.u.qiniudn.com/docs/v6/tools/qrsync.html)


/Users/xbin999/bin/qrsync /Users/xbin999/bin/qiniu-conf.json 2>&1 |sed -e 's/\(=> xbin999:\)\(.*\)/=> ![](http:\/\/7b1ha1.com1.z0.glb.clouddn.com\/\2\)/' >/Users/xbin999/tmp/.qiniu.log

cat /Users/xbin999/tmp/.qiniu.log |grep "\!\[\]" | awk -F '=>' '{print $2}' | pbcopy

cat /Users/xbin999/tmp/.qiniu.log