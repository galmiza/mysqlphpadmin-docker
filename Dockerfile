FROM ubuntu:20.04
ENV TZ=Europe/Paris
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt update -y && apt upgrade -y && apt clean -y && \
    apt install -y wget zip mysql-server nginx vim cron && \
    apt install -y php7.4-fpm php-mysqli php-xml
COPY nginx.conf configure.sh start.sh /
RUN /bin/bash configure.sh
CMD ["/bin/bash","start.sh"]
