FROM lazygeniusman/processmaker:base-4.1 as build
ARG PM_VERSION=4.1.21

WORKDIR /var/www/html
RUN set -eux; \
# Download and extract processmaker tarball
	curl -o processmaker.tar.gz -fL "https://github.com/ProcessMaker/processmaker/archive/refs/tags/v$PM_VERSION.tar.gz"; \
	tar -xzf processmaker.tar.gz --strip-components=1 -C /var/www/html/; \
	rm processmaker.tar.gz; \
    rm -rf \
        .circleci \
        .git \
        .gitbook \
        .github \
        docs \
        getting-started \
        homestead \
        jest \
        tests

RUN composer install \
    --no-cache \
    #--no-dev \
    #--optimize-autoloader \
    && rm -rf /tmp/* /var/tmp/*

RUN npm install --unsafe-perm=true && npm run prod
COPY /docker /

RUN chmod 0644 /etc/cron.d/laravel-cron && crontab /etc/cron.d/laravel-cron;
CMD bash init.sh && supervisord --nodaemon
