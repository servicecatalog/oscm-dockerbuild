#!/bin/sh

remove_css () {
  branding_dir="$1"
  if [ -d $branding_dir/css ]; then
    rm -rf $branding_dir/css
  fi
  if [ -d $branding_dir/customBootstrap/css ]; then
    rm -rf $branding_dir/customBootstrap/css
  fi
}

compile_sass () {
  for dir in /*/
  do
    $package_dir=${dir%*/}
    remove_css $package_dir
    sass $package_dir/scss/*.scss $package_dir/css/*.css
    sass $package_dir/customBootstrap/scss/*.scss $package_dir/customBootstrap/css/*.css
    for i in $package_dir/css/*.css; do java -jar ./yuicompressor-2.4.7.jar $i -o $(echo $i | sed 's/\.css/\.min\.css/g'); done;
    for i in $package_dir/customBootstrap/css/*.css; do java -jar ./yuicompressor-2.4.7.jar $i -o $(echo $i | sed 's/\.css/\.min\.css/g'); done;
  done
}

compile_sass
