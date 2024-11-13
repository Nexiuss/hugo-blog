# Nexiuss.github.io
## hugo 命令
1. 创建一个新的posts
`hugo new posts/xxx.md`
2. 创建一个新的projects
`hugo new projects/xxx.md`
3. 引入图片
Hugo博客源码根目录下的static目录是用来存放一些静态文件的（包括图片），执行hugo -F生成的public文件夹，会将static目录下的文件一并导入至public文件夹，并最终呈现至服务器网页上。
所以想要在markdown里引用本地图片，那么就在根目录的static目录下存放图片，并在mardown里引用就可以了。
如：文件放入static/images目录下，在markdown里引用本地图片
`![](/images目录下/xxx.png)`

4. 本地预览
`hugo server`
5. 构建public目录，生成线上代码
`hugo`
