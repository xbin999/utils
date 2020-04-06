一些小工具。

# qiniu_md.sh
上传配置中指定目录的图像文件到七牛云，同时复制图像的markdown格式到剪贴板。

- 依赖于[qrsync](http://qiniu-developer.u.qiniudn.com/docs/v6/tools/qrsync.html)

# combineimg.sh
提供电影字幕的图像拼接，参考图片 ![](http://7b1ha1.com1.z0.glb.clouddn.com/images/xbin_IMG_1116.PNG.jpg)
。

- 依赖于[Command-line Tools: Convert @ ImageMagick](https://www.imagemagick.org/script/convert.php)

# blog
结合daemon，实现hexo博客的自动发布。
将指定目录形如 publish^tag1_tag2^helloworld.md的文件解析生成hexo 博客的头，同时调用hexo generate --deploy 完成静态博客的编译和发布。

- 依赖于[Hexo](https://hexo.io/)

# video100days
从一批视频文件中随机截取1秒来生成一个新的视频，文件名需要排序并会作为视频标题，可以用于100天的行动。

- 依赖于[ffmpeg](https://ffmpeg.org/)
