一些小工具。

# qiniu_md.sh
上传配置中指定目录的图像文件到七牛云，同时复制图像的markdown格式到剪贴板。

# blog
结合daemon，实现hexo博客的自动发布。
将指定目录形如 publish^tag1_tag2^helloworld.md的文件解析生成hexo 博客的头，同时调用hexo generate --deploy 完成静态博客的编译和发布。
