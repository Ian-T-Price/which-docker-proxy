# Set the version of our httpd image from Docker Hub

FROM httpd:2.4.46

# Update & install utilities 
# RUN apt-get update && apt-get install -y wget nano
# Turning off update during dev
RUN apt-get install -y wget nano

# setting the work directory
WORKDIR /usr/local/apache2

COPY httpd.conf.tpl ./conf/httpd.conf

# Extended health check of our container
HEALTHCHECK CMD wget -q --method=HEAD https://www.which.co.uk
