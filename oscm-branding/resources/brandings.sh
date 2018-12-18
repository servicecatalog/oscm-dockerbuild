#!/bin/sh

while inotifywait -e create /import/brandings; do
	if [ ${SOURCE} == "LOCAL" ]; then
		/usr/bin/cp ${BRANDING_DIR}/*.tar.gz /tmp/work
	fi

	for file in /tmp/work/*.tar.gz
	do
    	/bin/tar -zxf $file -C /usr/share/nginx/html/
	done
	
	/usr/bin/chown -R nginx: /usr/share/nginx/html/
	/usr/bin/rm -r /tmp/work
done
