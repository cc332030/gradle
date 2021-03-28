# gradle 创建软链接

gradle_path=./data/wrapper/dists/gradle-$1-all
# 判断是否存在该版本
if [ ! -d $gradle_path ]; then
  echo $gradle_path not exists
  exit
fi

gradle_sub_path=$gradle_path/`ls $gradle_path | head -n 1`
gradle_path=$gradle_sub_path/gradle-$1

echo gradle_path=$gradle_path

# 判断是否解压
if [ ! -d $gradle_path ]; then
  echo start unzip
  unzip -q $gradle_path-all.zip -d $gradle_sub_path
fi

rm -f app
ln -s $gradle_path app
