# Set the version of our httpd image from Docker Hub
ARG REFRESH_TIME=9
FROM httpd:2.4.46
ARG REFRESH_TIME
ARG UNSET_HEADER
ARG SET_HEADER


# Update & install utilities 
RUN apt-get update && apt-get install -y wget nano
# Turning off update during dev
# RUN apt-get install -y wget nano

# Add helper programs for all users
RUN echo '#!/usr/bin/env bash\nls -lsa "$@"' > /usr/bin/ll && chmod +x /usr/bin/ll
# alias for ps
RUN echo '#!/usr/bin/env bash\n\nshopt -s extglob\n\nfor i in $(cd /proc && echo \
  +([0-9])); do echo -n "$i " ; if [ -f /proc/$i/cmdline ] ; \
  then cat /proc/$i/cmdline ; fi ; echo ; done' > /usr/bin/ps && chmod +x /usr/bin/ps

# Set the environment varibles
ENV APACHE_LOG_DIR "/usr/local/apache2/logs"
ENV REFRESH=$REFRESH_TIME
ENV UNSET_HTTP_HEADER="$UNSET_HEADER"
ENV SET_HTTP_HEADER="$SET_HEADER"

# setting the work directory
WORKDIR /usr/local/apache2

# Create required httpd config
COPY httpd.tpl.conf ./conf/

RUN if [ ! -z "$UNSET_HTTP_HEADER" ] ; \
  then sed '/RequestHeader unset Proxy early/i \ \ \ \ RequestHeader unset '"$UNSET_HTTP_HEADER"'' ./conf/httpd.tpl.conf > ./conf/httpd.tpl2.conf ; fi

RUN if [ ! -z "$SET_HTTP_HEADER" ] ; \
  then sed '/RequestHeader unset Proxy early/i \ \ \ \ RequestHeader set '"$SET_HTTP_HEADER"'' ./conf/httpd.tpl2.conf > ./conf/httpd.tpl3.conf ; fi

RUN cp -f ./conf/httpd.tpl3.conf ./conf/httpd.conf && apachectl -k restart

COPY httpd-info.conf ./conf/extra/

COPY index.html favicon.ico ./htdocs/
RUN sed -i 's/refresh=INT/refresh='"$REFRESH"'/' ./htdocs/index.html 
RUN cd ./htdocs && mkdir status && cp index.html status/
RUN chown -R www-data: ./htdocs && chmod +rx ./htdocs/favicon.ico

# Extended health check of our container
HEALTHCHECK CMD wget -q --method=HEAD https://www.which.co.uk
