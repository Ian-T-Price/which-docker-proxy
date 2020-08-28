# Set the version of our httpd image from Docker Hub

FROM httpd:2.4.46

# Update container
RUN apt update

# Extended health check of our container
HEALTHCHECK CMD wget -q --method=HEAD https://www.which.co.uk
