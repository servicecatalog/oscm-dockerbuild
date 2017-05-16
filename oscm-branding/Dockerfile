FROM nginx:mainline

ENV BRANDING_DIR=/brandings

COPY start.sh /opt/start.sh

RUN chmod +x /opt/start.sh && \
    rm /usr/share/nginx/html/index.html

EXPOSE 80 443

CMD ["/opt/start.sh"]
