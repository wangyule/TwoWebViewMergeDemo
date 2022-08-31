#CocoaPods1.8+强制安装了新的源trunk，采用cdn替换了原本的master
#直接通过cdn方式更新本地库
#source 'https://cdn.cocoapods.org/'
#指定旧方式下载(master)
#source 'https://github.com/CocoaPods/Specs.git'
source 'https://mirrors.tuna.tsinghua.edu.cn/git/CocoaPods/Specs.git'
# Uncomment this line to define a global platform for your project
platform :ios, '9.0'

#Uncomment this line if you're using swift or would like to use dynamic frameworks
#指定生成framework库，否则默认会生成.a静态库
use_frameworks!

pod 'Masonry'
pod 'MJRefresh'
pod 'SDWebImage'

# 解决每次更新pod时，试运行等其他target就会编译报错的问题   2019.08.28
# 项目中的target各自的设置
target 'TwoWebViewMergeDemo' do
  #可以在这里添加"TwoWebViewMergeDemo"独自引用的pod第三方
end

