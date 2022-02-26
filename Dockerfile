FROM pm-base:4.1-test
ARG PM_VERSION=4.1.21

WORKDIR /var/www/html
RUN set -eux; \
# Download and extract processmaker tarball
	curl -o processmaker.tar.gz -fL "https://github.com/ProcessMaker/processmaker/archive/refs/tags/v$PM_VERSION.tar.gz"; \
	tar -xzf processmaker.tar.gz --strip-components=1 -C /var/www/html/; \
	rm processmaker.tar.gz;
COPY docker/laravel-echo-server.json .
COPY --chmod=644 docker/laravel-cron /etc/cron.d/laravel-cron
COPY docker/nginx.conf /etc/nginx/nginx.conf
COPY docker/services.conf /etc/supervisor/conf.d/services.conf
COPY docker/laravel-echo-server.json /var/www/html/laravel-echo-server.json
COPY docker/init.sh /var/www/html/init.sh

RUN composer install \
    --no-cache \
    --no-dev \
    --optimize-autoloader; \

RUN npm install --unsafe-perm=true && npm run dev

CMD bash init.sh && supervisord --nodaemon
