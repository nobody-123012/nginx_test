FROM centos:7

RUN groupadd -g 101 nginx && adduser -u 101 -d /var/cache/nginx -s /sbin/nologin -g nginx nginx
COPY ./nginx.conf /opt/nginx.conf
COPY ./headers-more-nginx-module.zip /opt/headers-more-nginx-module.zip
WORKDIR /opt
RUN cd /opt/ \
    && yum -y install pcre pcre-devel zlib zlib-devel openssl openssl-devel patch gcc
    glibc-devel make gd-devel geoip-devel perl-devel wget unzip \
    && wget http://nginx.org/download/nginx-1.18.0.tar.gz \
    && tar -zxvf nginx-1.18.0.tar.gz \
    && rm -rf nginx-1.18.0.tar.gz \
    && unzip -d /opt/ headers-more-nginx-module.zip \
    && rm -rf headers-more-nginx-module.zip \
    && cd nginx-1.18.0 \
    && ./configure --user=nginx --group=nginx --prefix=/usr/local/nginx --with-
    http_ssl_module --with-http_stub_status_module --with-http_realip_module --with-threads
    --with-file-aio --add-module=/opt/headers-more-nginx-module-master \
    && cores=$(cat /proc/cpuinfo| grep "processor"| wc -l) \
    && make -j $cores \
    && make \
    && make install \
    && ln -s /usr/local/nginx/sbin/nginx /usr/bin/nginx \
    && mkdir /var/log/nginx/ \
    && mkdir /usr/local/nginx/logs/nginx \
    && mv /usr/local/nginx/conf/nginx.conf /usr/local/nginx/conf/nginx.conf.bak \
    && cp /opt/nginx.conf /usr/local/nginx/conf/nginx.conf
    
CMD ["nginx", "-g", "daemon off;"]
