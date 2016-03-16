
# 不要将此文件加入到工程文件中，放在工程根目录下即可

# 获取编译目录Info.plist(可能是其他名字)文件地址
INFOPLISTPATH_BUILD="${TARGET_BUILD_DIR}/${EXECUTABLE_NAME}.app/Info.plist"
# 获取工程目录Info.plist(可能是其他名字)文件地址
# INFOPLISTPATH_PROJC= PRODUCT_SETTINGS_PATH



# 可以打印出这个地址，在xcode的build记录中可以找到
# 在DerivedData目录下～/Library/Developer/Xcode/DerivedData的
# /EXECUTABLE_NAME-xxx/Build/Products/Debug-iphoneos/EXECUTABLE_NAME.app/Info.plist
# /EXECUTABLE_NAME-xxx/Build/Products/Debug-iphoneos/EXECUTABLE_NAME.app/Settings.bundle
# /EXECUTABLE_NAME-xxx/Build/Products/Debug-iphoneos/EXECUTABLE_NAME.app.dSYM
echo "INFOPLISTPATH_BUILD: ${INFOPLISTPATH_BUILD}"

# 获取工程中的Info.plist文件地址
# echo "$PRODUCT_SETTINGS_PATH"

# 获取操作plist文件的程序地址
PLISTBUDDY="/usr/libexec/PlistBuddy"

# 获取所在工程git的commitid（最少4位）
# git rev-parse --short HEAD (取前7位)
# git rev-parse --short=12 HEAD (取前12位)
# git rev-parse HEAD (取全部)
GITREVSHA=$(git --git-dir="${PROJECT_DIR}/.git" --work-tree="${PROJECT_DIR}" rev-parse --short=12 HEAD)
echo "GITHash: ${GITREVSHA})"

## 获取build版本号，如20160103
build_version=`date "+%Y%m%d%H%M"`





## 设置GITHash
# 需要提前在工程中的Info.plist中加入GITHash项，值随意
# 设置编译目录中Info.plist的GITHash
$PLISTBUDDY -c "Set :GITHash $GITREVSHA" "${INFOPLISTPATH_BUILD}"
# 设置工程目录中Info.plist的GITHash
$PLISTBUDDY  -c "Set :GITHash $GITREVSHA" $PRODUCT_SETTINGS_PATH

## 设置build version
# /usr/libexec/PlistBuddy -c "Set :CFBundleVersion $build_version" $PRODUCT_SETTINGS_PATH
# 设置编译目录中Info.plist的build版本号
$PLISTBUDDY  -c "Set :CFBundleVersion $build_version" $INFOPLISTPATH_BUILD
# 设置工程目录中Info.plist的build版本号
$PLISTBUDDY  -c "Set :CFBundleVersion $build_version" $PRODUCT_SETTINGS_PATH

## 工程中加入Settings.bundle并设置如图settings-bundle.png
## 在启动后设置如下
## 注意key需要对应Settings.bundle中的Identifier
# NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
# [[NSUserDefaults standardUserDefaults] setObject:version forKey:@"version_preference"];

# NSString *build = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
# [[NSUserDefaults standardUserDefaults] setObject:build forKey:@"build_preference"];

# NSString *githash = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"GITHash"];
# [[NSUserDefaults standardUserDefaults] setObject:githash forKey:@"githash_preference"];

## 注意！！！
# 由于编译时向工程目录的Info.plist更新了内容
# 如提交后commitid为12345，之后编译得到发布产品A，这时修改了工程目录的Info.plist的GITHash和buildVersion
# 此时产生新了的修改项待提交，因此工程中的这两项与发布的产品A的版本号，GITHash不一致

## 工程中的GITHash仅作为参考，实际应该为它的下一次提交

#	动作				时间	  	Info.plist.commitid	 	是否为发布版		git.commitid 
# -------------------------------------------------------------------------------
#	bug修改完成		16:00  	ABCDE					否				---			 
#	提交				16:01	ABCDE					否				BBCDE
#	编译发布版		16:02	BBCDE					是 				
#	提交改动			16:03	BBCDE					否				CBCDE
# -------------------------------------------------------------------------------
## 实际上发布版中Info.plist中的GITHash为其上一次的commitid
## 因此在编译发布版之前，一定要先提交，再编译（此时会更改build_time和GITHash），之后再次提交，完成此版
## 当出现问题时，返回来的是BBCDE，此时查找git仓库的BBCDE的下一次（即CBCDE），chekcout此代码即可

## 不知道有没更好的方法！！！

## 问题在于编译时获得的是上一次commit的id

## 解决方案一
# 不在编译时改写工程目录中的build_time和GITHash
# 编译时仅改写编译目录中的build_time和GITHash
# 完全提交到git服务器之后再编译出发布版
# 出现问题时按照时间、commitid找即可


