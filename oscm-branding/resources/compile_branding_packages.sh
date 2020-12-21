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
  for dir in /import/brandings/*; do
    remove_css $dir
    for i in $dir/scss/*; do
      file="${i##*/}"
      if [[ $file != _* ]] && [[ ${file: -5} == ".scss" ]]; then
        name="${file%%.*}"
        sass $dir/scss/$name.scss $dir/css/$name.css
      fi
    done;
    for i in $dir/customBootstrap/scss/*; do
      file="${i##*/}"
      if [[ $file != _* ]] && [[ ${file: -5} == ".scss" ]]; then
        name="${file%%.*}"
        sass $dir/customBootstrap/scss/$name.scss $dir/customBootstrap/css/$name.css
      fi
    done;
    for i in $dir/css/*.css; do java -jar /usr/local/yuicompressor-2.4.7.jar $i -o $(echo $i | sed 's/\.css/\.min\.css/g'); done;
    for i in $dir/customBootstrap/css/*.css; do java -jar /usr/local/yuicompressor-2.4.7.jar $i -o $(echo $i | sed 's/\.css/\.min\.css/g'); done;
  done
}

compile_sass
