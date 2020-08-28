# Set the version of our httpd image from Docker Hub

FROM httpd:2.4.46

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

# setting the work directory
WORKDIR /usr/local/apache2

COPY httpd.conf.tpl ./conf/httpd.conf
COPY index.html favicon.ico ./htdocs/
RUN cd ./htdocs && mkdir status && cp index.html status/

# Extended health check of our container
HEALTHCHECK CMD wget -q --method=HEAD https://www.which.co.uk
