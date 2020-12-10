#!/bin/sh

branding="$1"
branding_file="${branding##*/}"
branding_name="${branding_file%.*}"
package_dir=config/brandings/$branding_name
mp_css=$package_dir/css/mp.min.css
custom_theme=$package_dir/customBootstrap/css/customTheme.min.css

compile_sass () {
  sass $package_dir/scss/mp.scss $package_dir/css/mp.css
  sass $package_dir/customBootstrap/scss/customFooter.scss $package_dir/customBootstrap/css/customFooter.css
  sass $package_dir/customBootstrap/scss/customTheme.scss $package_dir/customBootstrap/css/customTheme.css
  docker cp oscm-core:opt/apache-tomee/webapps/oscm-portal/WEB-INF/lib/yuicompressor-2.4.7.jar ./
  for i in $package_dir/**/*.css; do java -jar ./yuicompressor-2.4.7.jar $i -o $(echo $i | sed 's/\.css/\.min\.css/g'); done;
  rm -f yuicompressor-2.4.7.jar
}

if [ -d $package_dir ]; then
  echo "ERROR: The folder cannot be created because the folder $branding_name already exists. Rename the file/folder which you want to compile or delete $package_dir"
  exit 1
fi

if [ ${branding: -4} == ".zip" ] || [ ${branding: -4} == ".bz2" ] || [ ${branding: -7} == ".tar.gz" ]; then
  unzip $branding -d ./config/brandings
  compile_sass
else
  compile_sass
fi

if [ -f "$mp_css" ] && [ -f "$custom_theme" ]; then
  echo "SUCCESS"
else
  echo "WARNING: Something goes wrong. Check the logs"
fi
