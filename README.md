# which-docker-proxy

A forward proxy running on Apache2 in a docker container

## See the Technical Test .pdf for full details


### To build:

```bash docker-build.sh```

### To access container:

```docker exec -it docker-proxy bash```

### To view output:

[In browser, navigate to http://localhost:8080](http://localhost:8080)

_**NOTE:**_ To use the proxy it is necessary to add the IP address and port to 
the Network Proxy settings[Ubuntu Setup](https://www.webservertalk.com/configure-proxy-on-ubuntu).

_**THIS ONLY WORKS ON FIREFOX**_  Chrome/Brave should use the system settings 
but they do not recognise them AND if you try to run from the command line 
using `google-chrome --proxy-server=host_ip:port` it fails
