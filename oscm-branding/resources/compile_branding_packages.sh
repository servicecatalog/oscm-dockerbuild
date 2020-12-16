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
  for dir in /import/brandings/*
  do
    remove_css $dir
    sass $dir/scss/*.scss $dir/css/*.css
    sass $dir/customBootstrap/scss/*.scss $dir/customBootstrap/css/*.css
    for i in $dir/css/*.css; do java -jar ./yuicompressor-2.4.7.jar $i -o $(echo $i | sed 's/\.css/\.min\.css/g'); done;
    for i in $dir/customBootstrap/css/*.css; do java -jar ./yuicompressor-2.4.7.jar $i -o $(echo $i | sed 's/\.css/\.min\.css/g'); done;
  done
}

compile_sass
