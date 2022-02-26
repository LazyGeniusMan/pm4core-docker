FROM lazygeniusman/processmaker:base-4.1
ARG PM_VERSION=4.1.21

WORKDIR /var/www/html
RUN set -eux; \
# Download and extract processmaker tarball
	curl -o processmaker.tar.gz -fL "https://github.com/ProcessMaker/processmaker/archive/refs/tags/v$PM_VERSION.tar.gz"; \
	tar -xzf processmaker.tar.gz --strip-components=1 -C /var/www/html/; \
	rm processmaker.tar.gz;

RUN composer install \
    --no-dev \
    ;

RUN npm install --unsafe-perm=true && npm run dev
COPY /docker /
#
# clean up
# 
RUN chmod 0644 /etc/cron.d/laravel-cron && crontab /etc/cron.d/laravel-cron &&\
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

CMD bash init.sh && supervisord --nodaemon
