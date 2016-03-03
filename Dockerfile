FROM debian:jessie
MAINTAINER Jimmy Xiao <xjm1285@gmail.com>

#RUN echo "deb http://mirrors.ustc.edu.cn/debian jessie main contrib non-free" > /etc/apt/sources.list && \
#    echo "deb-src http://mirrors.ustc.edu.cn/debian jessie main contrib non-free" >> /etc/apt/sources.list && \
#    echo "deb http://mirrors.ustc.edu.cn/debian jessie-proposed-updates main contrib non-free" >> /etc/apt/sources.list && \
#    echo "deb-src http://mirrors.ustc.edu.cn/debian jessie-proposed-updates main contrib non-free" >> /etc/apt/sources.list && \
#    echo "deb http://mirrors.ustc.edu.cn/debian jessie-updates main contrib non-free" >> /etc/apt/sources.list && \
#    echo "deb-src http://mirrors.ustc.edu.cn/debian jessie-updates main contrib non-free" >> /etc/apt/sources.list
RUN export DEBIAN_FRONTEND='noninteractive' && apt-get update -y -qq && \
    apt-get install -qq ca-certificates php5 php5-fpm php5-dev php5-cli php-pear php5-mysql php5-json php5-mcrypt php5-gd php5-curl php5-intl php5-redis php5-imap zip unzip && \
    pear install mail_mime mail_mimedecode net_smtp net_idna2-beta auth_sasl net_sieve crypt_gpg && \
    pecl install xdebug && \
    rm -rf /var/lib/apt/lists/*

RUN sed -i -e "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g" /etc/php5/fpm/php.ini && \
  sed -i -e "s/upload_max_filesize\s*=\s*2M/upload_max_filesize = 100M/g" /etc/php5/fpm/php.ini && \
  sed -i -e "s/post_max_size\s*=\s*8M/post_max_size = 100M/g" /etc/php5/fpm/php.ini && \
  sed -i -e "s|;date.timezone =|date.timezone = Asia/Shanghai|" /etc/php5/fpm/php.ini && \
  sed -i "N;4izend_extension=/usr/lib/php5/20131226/xdebug.so" /etc/php5/fpm/php.ini && \
  sed -i "N;5ixdebug.remote_enable = on" /etc/php5/fpm/php.ini && \
  sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php5/fpm/php-fpm.conf && \
  sed -i -e "s/;catch_workers_output\s*=\s*yes/catch_workers_output = yes/g" /etc/php5/fpm/pool.d/www.conf && \
  sed -i -e "s|listen = /var/run/php5-fpm.sock|listen = 9000|" /etc/php5/fpm/pool.d/www.conf && \
  sed -i -e "s|^.*;env\[PATH\].*$|env[PATH] = $PATH|g" /etc/php5/fpm/pool.d/www.conf && \
  sed -i -e "s/pm.max_children = 5/pm.max_children = 9/g" /etc/php5/fpm/pool.d/www.conf && \
  sed -i -e "s/pm.start_servers = 2/pm.start_servers = 3/g" /etc/php5/fpm/pool.d/www.conf && \
  sed -i -e "s/pm.min_spare_servers = 1/pm.min_spare_servers = 2/g" /etc/php5/fpm/pool.d/www.conf && \
  sed -i -e "s/pm.max_spare_servers = 3/pm.max_spare_servers = 4/g" /etc/php5/fpm/pool.d/www.conf && \
  sed -i -e "s/pm.max_requests = 500/pm.max_requests = 200/g" /etc/php5/fpm/pool.d/www.conf && \
  sed -i -e "s/;listen.mode = 0660/listen.mode = 0750/g" /etc/php5/fpm/pool.d/www.conf && \
  sed -i -e "s|;always_populate_raw_post_data = -1|always_populate_raw_post_data = -1|" /etc/php5/fpm/php.ini && \
  find /etc/php5/cli/conf.d/ -name "*.ini" -exec sed -i -re 's/^(\s*)#(.*)/\1;\2/g' {} \;

EXPOSE 9000
CMD ["php5-fpm"]
